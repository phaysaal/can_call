int f2(){
	return 1;
}

void f3(){ }

void f1(int y){
	if(y<0){
		while(f2()){
			f3();
		}
	}
}

int main(){
	int x = 0;
	
	f1(x);
}
