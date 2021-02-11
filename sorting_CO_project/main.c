#include <stdio.h>
#include <stdlib.h>

void swap(int *xp, int *yp)
{
	int temp = *xp;
	*xp = *yp;
	*yp = temp;
}

// A function to implement bubble sort
void bubbleSort(int arr[], int n)
{
int i, j;
for (i = 0; i < n-1; i++)

	// Last i elements are already in place
	for (j = 0; j < n-i-1; j++)
		if (arr[j] > arr[j+1])
			swap(&arr[j], &arr[j+1]);
}

void swapString(char *xp, char *yp)
{
	char temp = *xp;
	*xp = *yp;
	*yp = temp;
}

// A function to implement bubble sort
void bubbleSortString(char arr[], int n)
{
int i, j;
for (i = 0; i < n-1; i++)

	// Last i elements are already in place
	for (j = 0; j < n-i-1; j++)
		if (arr[j] > arr[j+1])
			swapString(&arr[j], &arr[j+1]);
}

/*void selection(){
}*/
// Merges two subarrays of arr[].
// First subarray is arr[l..m]
// Second subarray is arr[m+1..r]
void merge(int arr[], int l, int m, int r)
{
    int i, j, k;
    int n1 = m - l + 1;
    int n2 = r - m;

    /* create temp arrays */
    int L[n1], R[n2];

    /* Copy data to temp arrays L[] and R[] */
    for (i = 0; i < n1; i++)
        L[i] = arr[l + i];
    for (j = 0; j < n2; j++)
        R[j] = arr[m + 1 + j];

    /* Merge the temp arrays back into arr[l..r]*/
    i = 0; // Initial index of first subarray
    j = 0; // Initial index of second subarray
    k = l; // Initial index of merged subarray
    while (i < n1 && j < n2) {
        if (L[i] <= R[j]) {
            arr[k] = L[i];
            i++;
        }
        else {
            arr[k] = R[j];
            j++;
        }
        k++;
    }

    /* Copy the remaining elements of L[], if there
    are any */
    while (i < n1) {
        arr[k] = L[i];
        i++;
        k++;
    }

    /* Copy the remaining elements of R[], if there
    are any */
    while (j < n2) {
        arr[k] = R[j];
        j++;
        k++;
    }
}

/* l is for left index and r is right index of the
sub-array of arr to be sorted */
void mergeSort(int arr[], int l, int r)
{
    if (l < r) {

        int m = l + (r - l) / 2;

        // Sort first and second halves
        mergeSort(arr, l, m);
        mergeSort(arr, m + 1, r);

        merge(arr, l, m, r);
    }
}

// Merges two subarrays of arr[].
// First subarray is arr[l..m]
// Second subarray is arr[m+1..r]
void mergeSting(char arr[], int l, int m, int r)
{
    int i, j, k;
    int n1 = m - l + 1;
    int n2 = r - m;

    /* create temp arrays */
    char L[n1], R[n2];

    /* Copy data to temp arrays L[] and R[] */
    for (i = 0; i < n1; i++)
        L[i] = arr[l + i];
    for (j = 0; j < n2; j++)
        R[j] = arr[m + 1 + j];

    /* Merge the temp arrays back into arr[l..r]*/
    i = 0; // Initial index of first subarray
    j = 0; // Initial index of second subarray
    k = l; // Initial index of merged subarray
    while (i < n1 && j < n2) {
        if (L[i] <= R[j]) {
            arr[k] = L[i];
            i++;
        }
        else {
            arr[k] = R[j];
            j++;
        }
        k++;
    }

    /* Copy the remaining elements of L[], if there
    are any */
    while (i < n1) {
        arr[k] = L[i];
        i++;
        k++;
    }

    /* Copy the remaining elements of R[], if there
    are any */
    while (j < n2) {
        arr[k] = R[j];
        j++;
        k++;
    }
}

/* l is for left index and r is right index of the
sub-array of arr to be sorted */
void mergeSortString(char arr[], int l, int r)
{
    if (l < r) {

        int m = l + (r - l) / 2;

        // Sort first and second halves
        mergeSortString(arr, l, m);
        mergeSortString(arr, m + 1, r);

        mergeSting(arr, l, m, r);
    }
}
/*void binary(){
}
*/
int main(void)
{
    // those are what the user choose
    int choice1,choice2;
    int dataint[10];
    int data;
    char datastring[10];
    printf("do you want to sort numbers or letters?\n");
    printf("enter 1 for numbers or 2 for letters\n");
    scanf("%d",&choice1);
    printf("what sorting algorithm do you want to be used?\n");
    printf("enter 1 for bubble sort, 2 for selection sort or 3 for merge sort\n");
    scanf("%d",&choice2);

    if(choice1==1){
        for(int i=0;i<10;i++){
            int turn=i+1;
            printf("please enter your digit number %d \n", turn);
            scanf("%d",&data);
            dataint[i]=data;
        }
        if(choice2==1){
            bubbleSort(dataint,10);
        }
        /*
        if(choice2==2){
            selection();
        }*/
        if(choice2==3){
            mergeSort(dataint,0,9);
        }
        for(int count=0;count<10;count++){
                printf("%d",dataint[count]);
        }
    }else if(choice1==2){
        printf("please enter 10 1etters\n");
        scanf("%s",datastring);
    }
        if(choice2==1){
            bubbleSortString(datastring,10);
        }
        /*if(choice2==2)
            selection();*/
        if(choice2==3){
            mergeSortString(datastring,0,9);
        }
            printf("%s\n",datastring);


return 0;
}
