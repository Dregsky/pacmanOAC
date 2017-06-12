#include <stdio.h>
#include <stdlib.h>

int main(){

int image[76800][3]; // first number here is 1024 pixels in my image, 3 is for RGB values
int color[500]; // cores distintas.
 FILE *streamIn, *bandeira, *corDistinta;
 streamIn = fopen("map.bmp", "rb");
 if (streamIn == (FILE *)0){
   printf("File opening error ocurred. Exiting program.\n");
   exit(0);
 }
bandeira = fopen("map.dat", "w");
corDistinta = fopen("cores_distintas.txt", "w");
 int byte;
 int count = 0;
 int j = 0;
 for(int i=0;i<54;i++) byte = getc(streamIn);  // strip out BMP header
//const char* string = ".byte";
//fprintf(bandeira, "%s ", string);
int z = 100, h = 76800;
 for(int i=0;i<h;i++){    // foreach pixel
    image[i][0] = getc(streamIn);  // use BMP 24bit with no alpha channel
    image[i][1] = getc(streamIn);  // BMP uses BGR but we want RGB, grab byte-by-byte
    image[i][2] = getc(streamIn);  // reverse-order array indexing fixes RGB issue...

    int r,g,b;
    b = image[i][0];
    g = image[i][1];
    r = image[i][2];
    b = (b * 3) / 255;
    g = (g * 7) / 255;
    r = (r * 7) / 255;
    g = (g << 2);
    r = (r << 5);
    int temp, indicador = 0;
    temp = b+g+r;
    fprintf(bandeira, "0x%X, ", temp);
    int k = 0;
    while(k <= j){
    	if(color[k] == temp){
    	   indicador = 1;
           break;
    	}else{
    	   k++;	
    	}
    }
    if(indicador == 0){
        color[j] = temp;
        fprintf(corDistinta, "0x%X\n", temp);
        j++;
    }
    //printf("pixel %d : [%X,%X,%X]\n",i+1,image[i][0],image[i][1],image[i][2]);
 }
 fclose(bandeira);
 fclose(corDistinta);
 fclose(streamIn);

}