#include<stdio.h>
#include<string.h>
#include<dlfcn.h>
typedef int (*fptr)(int, int);
int main(){
char op[10];
int num1,num2;
char lib[32];
while(scanf("%s %d %d",op,&num1,&num2)==3){
    strcpy(lib,"./lib");
    strcat(lib,op);
    strcat(lib,".so");
    void* handle=dlopen(lib, RTLD_LAZY);
    if(handle==NULL){
        continue;
    }
    fptr result=dlsym(handle, op); 
    if(result==NULL){
         dlclose(handle);
         continue;
    }
    int ans=result(num1,num2);
    printf("%d\n",ans);
    dlclose(handle);
    
}
}