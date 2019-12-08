#include <iostream>
#include <vector>
#include <algorithm>
#include <string>
using namespace std;

int numlen = 5;

string pad(double num)
{
	string temp = to_string(num);
	int offset = 1;
	if (temp.find_last_not_of('0') == temp.find('.'))
		offset = 0;
	temp.erase(temp.find_last_not_of('0') + offset, string::npos);
	if (temp.find('-')) // dirty deeds done dirt cheap
		temp.insert(0, " ");
	temp.append(numlen, ' ');
	return temp.substr(0, numlen);
}

class Simplex
{
public:
	int height = 0;
	int width = 0;
	vector<double> body;
	vector<double> coeffs;
	vector<double> values;
	double value = 0;

	Simplex(int h, int w)
	{
		height = h;
		width = w;
		body.resize(h * w, 0);
		coeffs.resize(w, 0);
		values.resize(h, 0);
	}
	~Simplex() {}
	double elem(int y, int x) const
	{
		int pos = (y - 1) * width + x - 1;
		return body[pos];
	}
	double elem(int y, int x, double v)
	{
		int pos = (y - 1) * width + x - 1;
		body[pos] = v;
		return body[pos];
	}
	double coeff(int x) const
	{
		int pos = x - 1;
		return coeffs[pos];
	}
	double coeff(int x, double v)
	{
		int pos = x - 1;
		coeffs[pos] = v;
		return coeffs[pos];
	}
	double val(int y) const
	{
		int pos = y - 1;
		return values[pos];
	}
	double val(int y, double v)
	{
		int pos = y - 1;
		values[pos] = v;
		return values[pos];
	}
	double fVal() const
	{
		return value;
	}
	double fVal(double v)
	{
		value = v;
		return value;
	}
	void resize(int h, int w)
	{
		if (h < height)
		{
			body.resize(h * width);
			values.resize(h);
			height = h;
		}
		if (w != width)
		{
			vector<double> temp = body;
			if (w > width)
			{
				fill(body.begin(), body.end(), 0);
				body.resize(w * height);
			}
			else if (w < width)
			{
				body.resize(w * height);
				fill(body.begin(), body.end(), 0);
			}
			int iterw = min(w, width);
			for (int y = 0; y < height; y++)
			{
				for (int x = 0; x < iterw; x++)
				{
					int oldpos = y * width + x;
					int newpos = y * w + x;
					body[newpos] = temp[oldpos];
				}
			}
			coeffs.resize(w);
			width = w;
		}
		if (h > height)
		{
			body.resize(h * width);
			values.resize(h);
			height = h;
		}
	}
	double xval(int x) const
	{
		int yPos = 0;
		if (coeff(x) == 0)
		{
			for (int t = 1; t <= height; t++)
			{
				yPos = 0;
				for (int y = 1; y <= height; y++)
				{
					yPos = t;
					if (!(y == t && elem(y, x) == 1 || y != t && elem(y, x) == 0))
					{
						yPos = 0;
						break;
					}
				}
				if (yPos)
					break;
			}
		}
		if (yPos)
			return val(yPos); // uuuh dirty
		else
			return 0;
	}
	int mx_coeff_indx() const
	{
		int nX = width - 3 * height;
		int nE = 4 * height - width;
		int pivX = 0;
		double maxE = -INFINITY;
		for (int x = 1; x <= height; x++)
		if (coeff(x) > maxE)
		{
			// from 1st X to last X and if corresp. Mu is 0
			if ((x >= 1 && x <= nX) && xval(x + nX + 2 * nE) == 0) 
			{
				pivX = x;
				maxE = coeff(x);
			}
			// from 1st Mu to last Mu and if corresp. X is 0
			else if ((x >= (nX + 2 * nE + 1) && x <= (2 * nX + 2 * nE)) && xval(x - nX - 2 * nE) == 0)
			{
				pivX = x;
				maxE = coeff(x);
			}
			// from 1st Zeta to last Xi and from 1st U to last A
			else if ((x >= (nX + 1) && x <= (nX + 2 * nE)) || (x >= (2 * nX + 2 * nE + 1)))
			{
				pivX = x;
				maxE = coeff(x);
			}
		}
		return pivX;
	}
	int smallest_valdiv() const
	{
		int pivX = mx_coeff_indx();
		if (pivX > 0)
		{
			int pivY = 0;
			double minD = INFINITY;
			for (int y = 1; y <= height; y++)
				if (val(y) / elem(y, pivX) < minD && val(y) / elem(y, pivX) >= 0)
				{
					pivY = y;
					minD = val(y) / elem(y, pivX);
				}
			return pivY;
		}
		return 0;
	}
	void table() const
	{
		cout << endl;
		for (int y = 1; y <= height; y++)
		{
			for (int x = 1; x <= width; x++)
				cout << " " << pad(elem(y, x)) << " |";
			cout << "| " << pad(val(y)) << endl;
		}
		cout << string((width+1)*(numlen+3), '=') << endl;
		for (int x = 1; x <= width; x++)
			cout << " " << pad(coeff(x)) << " |";
		cout << "| " << pad(fVal()) << endl << endl;
	}
	void vars() const
	{
		int nX = width - 3 * height;
		int nE = 4 * height - width;
		for (int x = 1; x <= nX; x++)
			cout << "x" << x << "  = " << xval(x) << endl;
		for (int x = 1; x <= nE; x++)
			cout << "Zt" << x << " = " << xval(nX + x) << endl;
		for (int x = 1; x <= nE; x++)
			cout << "Xi" << x << " = " << xval(nX + nE + x) << endl;
		for (int x = 1; x <= nX; x++)
			cout << "Mu" << x << " = " << xval(nX + 2 * nE + x) << endl;
		for (int x = 1; x <= nX; x++)
			cout << "U" << x << "  = " << xval(2 * nX + 2 * nE + x) << endl;
		for (int x = 1; x <= nX+nE; x++)
			cout << "Ar" << x << " = " << xval(3 * nX + 2 * nE + x) << endl;
		cout << "f(X) = " << fVal() << endl;
	}

	
	Simplex(const Simplex & obj)
	{
		width = obj.width;
		height = obj.height;
		body = obj.body;
		coeffs = obj.coeffs;
		values = obj.values;
		value = obj.value;

		int pivX = obj.mx_coeff_indx();
		int pivY = obj.smallest_valdiv();
		if (pivX > 0 && pivY > 0)
		{
			double pivVal = obj.elem(pivY, pivX);
			for (int y = 1; y <= height; y++)
			{
				if (y == pivY)
				{
					for (int x = 1; x <= width; x++)
						elem(pivY, x, obj.elem(pivY, x) / pivVal);
					val(y, val(pivY) / pivVal);
				}
				else
				{
					for (int x = 1; x <= width; x++)
						elem(y, x, obj.elem(y, x) - obj.elem(pivY, x) * obj.elem(y, pivX) / pivVal);
					val(y, obj.val(y) - obj.elem(y, pivX) * obj.val(pivY) / pivVal);
				}
			}
			for (int x = 1; x <= width; x++)
				coeff(x, obj.coeff(x) - obj.elem(pivY, x) * obj.coeff(pivX) / pivVal);
			fVal(obj.fVal() - obj.val(pivY) * obj.coeff(pivX) / pivVal);
		}
	}
	Simplex & operator= (const Simplex & obj)
	{
		if (this != &obj)
		{
			height = obj.height;
			width = obj.width;
			body.resize(height * width, 0);
			coeffs.resize(width, 0);
			values.resize(height, 0);
			body = obj.body;
			coeffs = obj.coeffs;
			values = obj.values;
			value = obj.value;
		}
		return *this;
	}
};

int main()
{
	Simplex prev(6, 22);
	{
		prev.elem(1, 1, 2.000000);   	prev.elem(1, 2, 3.000000);   	prev.elem(1, 3, 1.000000);   	prev.elem(1, 4, 0.000000);   	prev.elem(1, 5, 0.000000);   	prev.elem(1, 6, 0.000000);   	prev.elem(1, 7, 0.000000);   	prev.elem(1, 8, 0.000000);   	prev.elem(1, 9, 0.000000);   	prev.elem(1, 10, 0.000000);   	prev.elem(1, 11, 0.000000);   	prev.elem(1, 12, 0.000000);   	prev.elem(1, 13, 0.000000);   	prev.elem(1, 14, 0.000000);   	prev.elem(1, 15, 0.000000);   	prev.elem(1, 16, 0.000000);   	prev.elem(1, 17, 1.000000);   	prev.elem(1, 18, 0.000000);   	prev.elem(1, 19, 0.000000);   	prev.elem(1, 20, 0.000000);   	prev.elem(1, 21, 0.000000);   	prev.elem(1, 22, 0.000000);   	prev.val(1, 6.000000);
		prev.elem(2, 1, 2.000000);   	prev.elem(2, 2, 1.000000);   	prev.elem(2, 3, 0.000000);   	prev.elem(2, 4, 1.000000);   	prev.elem(2, 5, 0.000000);   	prev.elem(2, 6, 0.000000);   	prev.elem(2, 7, 0.000000);   	prev.elem(2, 8, 0.000000);   	prev.elem(2, 9, 0.000000);   	prev.elem(2, 10, 0.000000);   	prev.elem(2, 11, 0.000000);   	prev.elem(2, 12, 0.000000);   	prev.elem(2, 13, 0.000000);   	prev.elem(2, 14, 0.000000);   	prev.elem(2, 15, 0.000000);   	prev.elem(2, 16, 0.000000);   	prev.elem(2, 17, 0.000000);   	prev.elem(2, 18, 1.000000);   	prev.elem(2, 19, 0.000000);   	prev.elem(2, 20, 0.000000);   	prev.elem(2, 21, 0.000000);   	prev.elem(2, 22, 0.000000);   	prev.val(2, 4.000000);
		prev.elem(3, 1, -2.000000);   	prev.elem(3, 2, 0.000000);   	prev.elem(3, 3, 0.000000);   	prev.elem(3, 4, 0.000000);   	prev.elem(3, 5, 2.000000);   	prev.elem(3, 6, 2.000000);   	prev.elem(3, 7, -2.000000);   	prev.elem(3, 8, -2.000000);   	prev.elem(3, 9, -1.000000);   	prev.elem(3, 10, -0.000000);   	prev.elem(3, 11, -0.000000);   	prev.elem(3, 12, -0.000000);   	prev.elem(3, 13, 1.000000);   	prev.elem(3, 14, 0.000000);   	prev.elem(3, 15, 0.000000);   	prev.elem(3, 16, 0.000000);   	prev.elem(3, 17, 0.000000);   	prev.elem(3, 18, 0.000000);   	prev.elem(3, 19, 1.000000);   	prev.elem(3, 20, 0.000000);   	prev.elem(3, 21, 0.000000);   	prev.elem(3, 22, 0.000000);   	prev.val(3, 2.000000);
		prev.elem(4, 1, -0.000000);   	prev.elem(4, 2, -0.000000);   	prev.elem(4, 3, -0.000000);   	prev.elem(4, 4, -0.000000);   	prev.elem(4, 5, -3.000000);   	prev.elem(4, 6, -1.000000);   	prev.elem(4, 7, 3.000000);   	prev.elem(4, 8, 1.000000);   	prev.elem(4, 9, 0.000000);   	prev.elem(4, 10, 1.000000);   	prev.elem(4, 11, 0.000000);   	prev.elem(4, 12, 0.000000);   	prev.elem(4, 13, -0.000000);   	prev.elem(4, 14, 1.000000);   	prev.elem(4, 15, -0.000000);   	prev.elem(4, 16, -0.000000);   	prev.elem(4, 17, 0.000000);   	prev.elem(4, 18, 0.000000);   	prev.elem(4, 19, 0.000000);   	prev.elem(4, 20, 1.000000);   	prev.elem(4, 21, 0.000000);   	prev.elem(4, 22, 0.000000);   	prev.val(4, 1.000000);
		prev.elem(5, 1, 0.000000);   	prev.elem(5, 2, 0.000000);   	prev.elem(5, 3, 0.000000);   	prev.elem(5, 4, 0.000000);   	prev.elem(5, 5, 1.000000);   	prev.elem(5, 6, 0.000000);   	prev.elem(5, 7, -1.000000);   	prev.elem(5, 8, -0.000000);   	prev.elem(5, 9, -0.000000);   	prev.elem(5, 10, -0.000000);   	prev.elem(5, 11, -1.000000);   	prev.elem(5, 12, -0.000000);   	prev.elem(5, 13, 0.000000);   	prev.elem(5, 14, 0.000000);   	prev.elem(5, 15, 1.000000);   	prev.elem(5, 16, 0.000000);   	prev.elem(5, 17, 0.000000);   	prev.elem(5, 18, 0.000000);   	prev.elem(5, 19, 0.000000);   	prev.elem(5, 20, 0.000000);   	prev.elem(5, 21, 1.000000);   	prev.elem(5, 22, 0.000000);   	prev.val(5, -0.000000);
		prev.elem(6, 1, 0.000000);   	prev.elem(6, 2, 0.000000);   	prev.elem(6, 3, 0.000000);   	prev.elem(6, 4, 0.000000);   	prev.elem(6, 5, 0.000000);   	prev.elem(6, 6, 1.000000);   	prev.elem(6, 7, -0.000000);   	prev.elem(6, 8, -1.000000);   	prev.elem(6, 9, -0.000000);   	prev.elem(6, 10, -0.000000);   	prev.elem(6, 11, -0.000000);   	prev.elem(6, 12, -1.000000);   	prev.elem(6, 13, 0.000000);   	prev.elem(6, 14, 0.000000);   	prev.elem(6, 15, 0.000000);   	prev.elem(6, 16, 1.000000);   	prev.elem(6, 17, 0.000000);   	prev.elem(6, 18, 0.000000);   	prev.elem(6, 19, 0.000000);   	prev.elem(6, 20, 0.000000);   	prev.elem(6, 21, 0.000000);   	prev.elem(6, 22, 1.000000);   	prev.val(6, -0.000000);
		prev.coeff(1, 2.000000);		prev.coeff(2, 4.000000);		prev.coeff(3, 1.000000);		prev.coeff(4, 1.000000);		prev.coeff(5, 0.000000);		prev.coeff(6, 2.000000);		prev.coeff(7, 0.000000);		prev.coeff(8, -2.000000);		prev.coeff(9, -1.000000);		prev.coeff(10, 1.000000);		prev.coeff(11, -1.000000);		prev.coeff(12, -1.000000);		prev.coeff(13, 1.000000);		prev.coeff(14, 1.000000);		prev.coeff(15, 1.000000);		prev.coeff(16, 1.000000);		prev.coeff(17, 0.000000);		prev.coeff(18, 0.000000);		prev.coeff(19, 0.000000);		prev.coeff(20, 0.000000);		prev.coeff(21, 0.000000);		prev.coeff(22, 0.000000);		prev.fVal(13.000000);
	}

	prev.table();
	prev.vars();

	while (true)
	{
		Simplex current(prev);
		if (current.fVal() >= prev.fVal())
			break;
		current.table();
		current.vars();
		prev = current;
	}

	return 0;
}
