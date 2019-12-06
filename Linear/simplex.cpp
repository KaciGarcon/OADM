#include "Simplex_class.cpp"

int main()
{
	Simplex prev(3, 5);
	{
		//elem(y, x, wartosc);
		prev.elem(1, 1, 2); 	prev.elem(1, 2, 7); 	prev.elem(1, 3, 1);
		prev.elem(2, 1, 2); 	prev.elem(2, 2, 1); 	prev.elem(2, 3, 0); 	prev.elem(2, 4, 1);
		prev.elem(3, 1, 3); 	prev.elem(1, 2, 0); 	prev.elem(3, 3, 0); 	prev.elem(2, 4, 0); 	prev.elem(3, 5, 1);
		
		//value (y, wartosc);
		prev.val(1, 42);
		prev.val(2, 12);
		prev.val(3, 15);
		
		//coeff(x, wartosc);
		prev.coeff(1, 1); 	prev.coeff(2, 2);
		
		// fVal (wartosc)
		prev.fVal(0);
	}
	
	prev.table();
	prev.vars();
	
	while (true)
	{
		Simplex current(prev);
		if (current.fVal >= prev.fVal)
			break;
		current.table();
		current.vars();
		prev = current;
	}
	
	return 0;
}
