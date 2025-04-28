// Evilson Vieira<evilson11@academico.ufs.br>
// Compilação: gcc bib.s challenge1.c -o challenge1
// Sintaxe: ./challenge1 input1.txt
// Saída1: output1.txt
// Saída2: output2.pbm (se o bloco final for descomentado)

#include <stdio.h>
#include <stdlib.h>

typedef struct maze Maze;
struct maze{
    unsigned char *m;
    Maze* prev;
    Maze* next;};

void set(unsigned char *pic, int j);
char tst(unsigned char *pic, int j);
void dta(unsigned int *data, int I, int J);
void new(unsigned char *pic,unsigned char *adj, unsigned int *data);
char trk(unsigned char *new,unsigned char *old, unsigned int *data, unsigned char *pic);
char trp(unsigned char *new,unsigned char *old, unsigned int *data, unsigned char *pic);

unsigned char rev (unsigned char a){
    unsigned char b,i;
    for(i=0;i<8;i++){
        b<<=1;
        b|=(a&1);
        a>>=1;}
        return b;
    }

    void print_maze(unsigned char *pic, int I, int J){
    int i,j,J8=(J+7)>>3;
    for(i=0;i<I;i++,pic+=J8){
        for(j=0;j<J;j++){
            if (tst(pic,j)) printf("1");
            else printf("0");}
        printf("\n");}
        printf("\n");}

void reverse(Maze *M, int K, int If, int Jf, int J8){
    int I8f=If*J8, i=I8f, j=Jf, k=K;
    unsigned char *F=malloc(K);
    while(k){
        k--;
        M=M->prev;
             if((j<Jf) &&(tst(M->m+i,j+1))) {j++;  F[k]='L';}
        else if((i<I8f)&&(tst(M->m+i+J8,j))){i+=J8;F[k]='U';}
        else if((j>0)  &&(tst(M->m+i,j-1))) {j--;  F[k]='R';}
        else                                {i-=J8;F[k]='D';}}
    FILE *file = fopen("output1.txt","w");
    for(i=0;i<K;i++) fprintf(file,"%c ",F[i]);
    fclose(file);
    printf("%d Moves\n",K);}

void main(int argc, char **argv){
    unsigned char *pic, *tmp, *t, S;
    int i, j, k, I, J, J8, If, Jf, U8;
    if(argc!=2) {printf("\nERRO!\nsintaxe: ./challenge1 <input>\n\n"); exit(0);}

    FILE *file = fopen(argv[1],"r");
    J=1; while (fgetc(file)!='\n') J++; J>>=1;
    I=2; while ((S=fgetc(file))!='4') if(S=='\n') I++;
    fclose(file);
    printf("\nI=%d J=%d\n",I,J);

    Jf=J-1, J8=(J+7)>>3, If=I-1, U8=I*J8;
    unsigned int data[3]={(If<<16)|I,(Jf<<16)|J,J8};
    //BAREMA                       0          4  8
    dta(data,I,J);

    pic=calloc(U8,1);
    tmp=malloc(U8);
    file = fopen(argv[1],"r");
    for(i=0,t=pic;i<I;i++,t+=J8){
        for(j=0;j<J;j++){
            if (fgetc(file)=='1') set(t,j);
            fgetc(file);}
        fgetc(file);}
    fclose(file);

    Maze *M=malloc(sizeof(Maze));
    M->prev=NULL;
    M->m=calloc(U8,1);
    M->m[0]=1;
    k=0;
    i=0;
    while(i==0){
        new(tmp,pic,data);
        t=tmp;tmp=pic;pic=t;
        M->next=malloc(sizeof(Maze));
        M->next->prev=M;
        M=M->next;
        M->m=malloc(U8);
        i=trk(M->m,M->prev->m,data,pic);
        k++;
    }

    reverse(M,k,If,Jf,J8);

// Descomente este bloco para obter uma imagem
// com todas as soluções ótimas mescladas
/*
    printf("Gerando imagem:\n");
    for(i=0;i<U8;i++) M->m[i]=pic[i]=0;
    set(M->m+U8-J8,Jf);
    set(pic+U8-J8,Jf);
    Maze *MM=M;
    while(k){
        trp(MM->prev->m,MM->m,data,pic);
        MM=MM->prev;
        k--;
        for(i=0;i<U8;i++) pic[i]|=MM->m[i];
        }
        file = fopen("output1.pbm", "w");
        fprintf(file, "P4\n");
        fprintf(file, "# Prof Evilson\n");
        fprintf(file, "%u %u\n", J, I);
        for (i=0; i<U8; i++)
            fprintf(file, "%c",rev(pic[i]));
        fclose(file);
*/
    while(M->prev!=NULL){
        free(M->m);
        M=M->prev;
        free(M->next);}
    free(M),free(pic),free(tmp);
    }
