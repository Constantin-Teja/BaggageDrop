# BaggageDrop
Teja Constantin

	Obiectivul este implementarea în Verilog al unui circuit combinațional care are ca scop simularea
aruncării automate a unui container cu provizii într-un câmp de luptă de către un elicopter către o echipă
de pușcași marini, în momentul când acesta se află în perimetrul autorizat. Pentru a nu fi neutralizat,
acesta trebuie să ajungă la sol într-un timp limită t, calculat cu ajutorul formulei t = sqrt(height) / 2.

	Modulul de top "baggage_drop" are 6 intrari (4 senzorii de inaltime), al cincilea timpul limita acceptat 
in care trebuie sa coboare elicopterul si al saselea un semnal care indica daca elicopterul se afla in
parametrul de aruncare. Are 5 iesiri: primele 4 semnale folosite pentru a comanda 4 elemente de tip 7seg,
pe care for fi afisate mesajele: "Hot", "CoLd" si "droP", si al cincilea semnal semnfica daca pachetul
a fost aruncat sau nu.

	Functionalitatea sa este realizata de 3 module interne:
	1. sensors_input
	2. square_root
	3. display_and_drop
	
	1. Primul modul, "sensors_input", primeste ca intrari semnalele de la senzorii de inaltime pe care le 
proceseaza si trimite ca iesire inaltimea la care se afla elicopterul astfel: senzorii sunt grupati cate 2,
daca unul din senzori are o valoare invalida automat nu va fi luat in considerare nici perechea acestuia.
Valoarea trimisa pe iesire reprezinta media aritmetica a valorilor valide (se considera ca cel putin o pereche
de senzori este valida). Aceasta medie este un numar intreg reprezentat pe 8 biti care este cel mai aproape
de valoarea reala. Alte detalii sunt prezente in comentariile din cod.

	2. Al doilea modul, "square_root", are o singura intrare si o singura iesire. Primeste pe intrare semnalul
procesat de modulul anterior (sensors_input), iar iesirea este un numar pe 16 biti reprezentat in virgula
fixa cu virgula intre bitul 7 si 8 ce este radacina patrata a numarului intreg primit pe intrare.
Metoda de calcul este CORDIC:
	Prima data am declarat 3 variabile de tip reg deoarece am nevoie sa le salvez valoarea pentru operatii:
	- sqrt: este pe 16 bit si este folosit pentru calculul radacinii patrare al numarului intreg
	- i: este un numar intreg reprezentat pe 5 biti folosit pentru un numar fix de 16 iteratii in for-ul din
	blocul always
	- base: este un numar pe 16 biti. Valoarea initiala este 16'h8000, adica bitul cel mai semnificativ este
	1 iar restul 0.
	La fiecare iteratie bitul din base este permutat la dreapta, acesta fiind motivul pentru care numarul
	de iteratii este 16. Ii este data ca valoarea initiala variabile sqrt 0 deoarece, la fiecare iteratie ii este
	adaugata baza. Dupa care se verifica daca numarul meu sqrt ridicat la patrat este mai mare decat cel dat ca
	intrare in modul. Daca este, inseamna ca numarul e prea mare asa ca ii scadem valoarea bazei adaugata la
	inceputul iteratiei, la sfarsitul iteratiei bitul 1 din base este permutat la dreapta. Astfel, dupa cele
	16 iteratii, in sqrt va avea valoarea radacinii patrare al numarului de 8 biti dat ca intrare in modul.
	Motivul pentru care bitul din base merge de la stanga la dreapta este pentru a se asigura ca se foloseste
	de fiecare data cea mai mare valoare posibila, in caz contrar valoarea lui sqrt in binar ar fi fost formata
	din 2 parti, prima parte de biti doar 0 iar restul din dreapta doar 1.
	Explicatie pentru "if(sqrt*sqrt > {8'd0,in,16'd0})": Din moment ce in este o variabile pe 8 biti intreaga
	iar rezultatul este un numar pe 16 biti cu virgula am considar ca este corect matematic sa inmultesc posibilul
	rezultat (sqrt) cu 2^8 pentru ca valoare sa fie tot una intreaga (deplasand astfel toti bitii din partea
	fractionala) pentru a putea calcula si compara valorile. Asadar, semnalul pe 16 biti ar avea inca 8 biti
	la dreapta fata de semnalul de intrare, iar la ridicarea sa la patrat pentru verificarea conditiei din if
	duce la 16 biti in coada semnalului. Din acest motiv ridicarea la patrat a valorii sqrt este comparata
	cu {8'd0, in, 16'd0}, unde in este semnalul de intrare. Primii 8 biti de 0 din fata este pentru a completa
	dimensiunea (deoarece sqrt este pe 16 biti, iar inmultirea a 2 numere pe 16 biti este reprezentata pe 32 de
	biti)
	
	3. Al treilea modul, "display_and_drop", are ca intrari: timpul de actionare, care este valoare calculata de
	modulul "sqrt_root" impartita la 2 (impartirea se faca intre modulul sqrt_root si display_and_drop in
	baggage_drop), timpul limita si drop_en. Timpii sunt reprezentati pe 16 biti in virgula fixa, iar drop_en
	pe un bit. Iesirilea acestui modul sunt iesirile modulului de top, baggage_drop. Acest modul se ocup cu
	afisarea mesajelor corespunzatoare si determinarea valorii lui drop_activated care indica daca a fost sau nu
	aruncat pachetul.
