#include <stdio.h>

int prime(int);

int main()
{
	int n,sir[100],rez[100],j=0;
	printf("list length = ");
	scanf("%d", &n);
	for (int i = 0;i < n;i++)
	{
		printf("Number %d: ", i + 1);
		scanf("%d", &sir[i]);
	}
	
	for (int i = 0;i < n;i++)
	{
		if (prime(sir[i]))
		{
			rez[j++] = sir[i];
		}
	}
	printf("The prime numbers are: ");
	for (int i = 0;i < j;i++)
	{
		printf("%d ", rez[i]);
	}
	return 0;
}