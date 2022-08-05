#include<stdio.h>

void f1(){}

void f2(){}

int main(){
	int x;
	scanf("%d", &x);
	switch(x){
	case 1:
		f1();
		break;
	default:
		f2();
	}
}
