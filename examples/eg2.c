void m1();
void m2();
void m3();
void m4();
void m5();
void m6();
void m7();
void m8();
void m9();
void m10();

void m1(){
	m2();
}

void m2(){
	m3();
}

void m3(){
	m4();
}

void m4(){
	m5();
}

void m5(){
	m6();
	m3();
}

void m6(){
	m2();
	m7();
}

void m7(){
	m8();
}

void m8(){
	m1();
}

void m9(){
	m10();
}

void m10(){
	m4();
}
