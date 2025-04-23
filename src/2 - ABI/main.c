#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>
#include <string.h>
#include <assert.h>

#include "../test-utils.h"
#include "ABI.h"

int main() {
	int result; //definido, no declarado. solo se declara si lo tenes en otro lado o aca.
	/* Acá pueden realizar sus propias pruebas */
	assert(alternate_sum_4_using_c(8, 2, 5, 1) == 10);

	assert(alternate_sum_4_using_c_alternative(8, 2, 5, 1) == 10);
	assert(alternate_sum_8(8,1,2,3,4,2,1,2) == 7);
	product_2_f(&result,5,3.5f);
	assert(result == 18);
	return 0;
	
}
