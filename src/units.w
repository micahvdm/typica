@* Unit information.

\noindent As unit information is required in several places, the enumeration
listing these is moved to an external class. This derives from QObject only to
take advantage of the meta-object system. There are no data members, however
there are some convenience methods for working with unit data.

@(units.h@>=
#include <QObject>

#ifndef TypicaUnitsIncluded
#define TypicaUnitsIncluded

class Units: public QObject
{
	Q_OBJECT
	Q_ENUMS(Unit)
	public:
		enum Unit
		{
			Unitless = 0,
			Fahrenheit = 10144,
			Celsius = 10143,
			Kelvin = 10325,
			Rankine = 10145,
			Pound = 15876,
			Kilogram = 15877,
			Ounce = 1,
			Gram = 2
		};
		static double convertTemperature(double value, Unit fromUnit, Unit toUnit);
		static double convertRelativeTemperature(double value, Unit fromUnit, Unit toUnit);
		static bool isTemperatureUnit(Unit unit);
		static double convertWeight(double value, Unit fromUnit, Unit toUnit);
		static bool isWeightUnit(Unit unit);
};

#endif

@ Methods are implemented in a separate file.

@(units.cpp@>=
#include "units.h"

@ The |isTemperatureUnit()| method may seem counter-intuitive while the enum
only contains represenations of temperature measurements, but there are plans
to extend this later to extend hardware support to devices that do not directly
measure temperature values and also to support the measurement of properties
that cannot sensibly be represented as temperatures such as fuel pressure and
control settings.

@(units.cpp@>=
bool Units::isTemperatureUnit(Unit unit)
{
	if(unit == Fahrenheit ||
	   unit == Celsius ||
	   unit == Kelvin ||
	   unit == Rankine)
	{
		return true;
	}
	return false;
}

@ Temperature conversions can be performed by the |Units| class and should
eliminate the need to have conversion code in multiple places. This method
takes the measurement value, the unit that value is in, and the unit that we
would like to have the measurement converted into. It returns the value as it
would be expressed after unit conversion. A value of 0 is presently returned
if either or both of the units to convert are not temperature units, however
that behavior may change in the future. Any code activating that branch should
be considered flawed.

@(units.cpp@>=
double Units::convertTemperature(double value, Unit fromUnit, Unit toUnit)
{
	if(isTemperatureUnit(fromUnit) && isTemperatureUnit(toUnit) == false)
	{
		return 0;
	}
	switch(fromUnit)
	{
		case Fahrenheit:
			switch(toUnit)
			{
				case Fahrenheit:
					return value;
					break;
				case Celsius:
					return (value - 32.0) * 5.0 / 9.0;
					break;
				case Kelvin:
					return (value + 459.67) * 5.0 / 9.0;
					break;
				case Rankine:
					return value + 459.67;
					break;
			}
			break;
		case Celsius:
			switch(toUnit)
			{
				case Fahrenheit:
					return value * 9.0 / 5.0 + 32.0;
					break;
				case Celsius:
					return value;
					break;
				case Kelvin:
					return value + 273.15;
					break;
				case Rankine:
					return (value + 273.15) * 9.0 / 5.0;
					break;
			}
			break;
		case Kelvin:
			switch(toUnit)
			{
				case Fahrenheit:
					return value * 5.0 / 9.0 - 459.67;
					break;
				case Celsius:
					return value - 273.15;
					break;
				case Kelvin:
					return value;
					break;
				case Rankine:
					return value * 9.0 / 5.0;
					break;
			}
			break;
		case Rankine:
			switch(toUnit)
			{
				case Fahrenheit:
					return value - 457.67;
					break;
				case Celsius:
					return (value - 491.67) * 5.0 / 9.0;
					break;
				case Kelvin:
					return value * 5.0 / 9.0;
					break;
				case Rankine:
					return value;
					break;
			}
			break;
		default:
			return 0;
			break;
	}
	return 0;
}

@ Conversions are also provided for relative temperature measurements.

@(units.cpp@>=
double Units::convertRelativeTemperature(double value, Unit fromUnit, Unit toUnit)
{
	if(isTemperatureUnit(fromUnit) && isTemperatureUnit(toUnit) == false)
	{
		return 0;
	}
	switch(fromUnit)
	{
		case Fahrenheit:
			switch(toUnit)
			{
				case Fahrenheit:
					return value;
					break;
				case Celsius:
					return value * (5.0 / 9.0);
					break;
				case Kelvin:
					return value * (5.0 / 9.0);
					break;
				case Rankine:
					return value;
					break;
				default:
					return 0;
					break;
			}
			break;
		case Celsius:
			switch(toUnit)
			{
				case Fahrenheit:
					return value * (9.0 / 5.0);
					break;
				case Celsius:
					return value;
					break;
				case Kelvin:
					return value;
					break;
				case Rankine:
					return value * (9.0 / 5.0);
					break;
				default:
					return 0;
					break;
			}
			break;
		case Kelvin:
			switch(toUnit)
			{
				case Fahrenheit:
					return value * (5.0 / 9.0);
					break;
				case Celsius:
					return value;
					break;
				case Kelvin:
					return value;
					break;
				case Rankine:
					return value * (9.0 / 5.0);
					break;
				default:
					return 0;
					break;
			}
			break;
		case Rankine:
			switch(toUnit)
			{
				case Fahrenheit:
					return value;
					break;
				case Celsius:
					return value * (5.0 / 9.0);
					break;
				case Kelvin:
					return value * (5.0 / 9.0);
					break;
				case Rankine:
					return value;
					break;
				default:
					return 0;
					break;
			}
			break;
		default:
			return 0;
			break;
	}
	return 0;
}

@ Units of force are handled similarly to units of temperature.

@(units.cpp@>=
double Units::convertWeight(double value, Unit fromUnit, Unit toUnit)
{
	if(isWeightUnit(fromUnit) && isWeightUnit(toUnit))
	{
		switch(fromUnit)
		{
			case Pound:
				switch(toUnit)
				{
					case Pound:
						return value;
						break;
					case Kilogram:
						return value / 2.2;
						break;
					case Ounce:
						return value * 16.0;
						break;
					case Gram:
						return value / 0.0022;
						break;
					default:
						return 0;
						break;
				}
				break;
			case Kilogram:
				switch(toUnit)
				{
					case Pound:
						return value * 2.2;
						break;
					case Kilogram:
						return value;
						break;
					case Ounce:
						return value * 35.2;
						break;
					case Gram:
						return value * 1000.0;
						break;
					default:
						return 0;
						break;
				}
				break;
			case Ounce:
				switch(toUnit)
				{
					case Pound:
						return value / 16.0;
						break;
					case Kilogram:
						return value / 35.2;
						break;
					case Ounce:
						return value;
						break;
					case Gram:
						return value / 0.0352;
						break;
					default:
						return 0;
						break;
				}
				break;
			case Gram:
				switch(toUnit)
				{
					case Pound:
						return value * 0.0022;
						break;
					case Kilogram:
						return value / 1000.0;
						break;
					case Ounce:
						return value * 0.0352;
						break;
					case Gram:
						return value;
						break;
					default:
						return 0;
						break;
				}
				break;
			default:
				return 0;
				break;
		}
	}
	return 0;
}

bool Units::isWeightUnit(Unit unit)
{
	if(unit == Pound ||
	   unit == Kilogram ||
	   unit == Ounce ||
	   unit == Gram)
	{
		return true;
	}
	return false;
}

@ This class is exposed to the host environment. Note the lack of constructor.
We do not wish to create any instances, just have access to the |Unit|
enumeration.

@<Set up the scripting engine@>=
value = engine->newQMetaObject(&Units::staticMetaObject);
engine->globalObject().setProperty("Units", value);

