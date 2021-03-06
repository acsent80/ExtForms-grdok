﻿////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Перем ОбъектОбработка;
	
	ОбъектОбработка = РеквизитФормыВЗначение("Объект");
	
	Если ЗначениеЗаполнено(Параметры.БизнесПроцесс) Тогда
		БизнесПроцесс = Параметры.БизнесПроцесс;
	КонецЕсли;
	РежимИспользованияМодальностиБулево = Параметры.РежимИспользованияМодальностиБулево;
	
	УсловныеОбозначения = ОбъектОбработка.ПолучитьМакет("КартаМаршрутаУсловныеОбозначения");
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ОбновитьКартуМаршрута();
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ФОРМЫ

&НаКлиенте
Процедура ОМОбновить()
	
	ОбновитьКартуМаршрута();
	
КонецПроцедуры

&НаКлиенте
Процедура ЗадачиВТочкеМаршрута()
	
	ОткрытьСписокЗадачТочкиМаршрута();
	
КонецПроцедуры

&НаКлиенте
Процедура КартаМаршрутаВыбор(Элемент)
	
	ОткрытьСписокЗадачТочкиМаршрута();
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ВСПОМОГАТЕЛЬНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаСервере
Процедура ОбновитьКартуМаршрута()

	Если ЗначениеЗаполнено(БизнесПроцесс) Тогда
		КартаМаршрута = БизнесПроцесс.ПолучитьОбъект().ПолучитьКартуМаршрута();
	ИначеЕсли БизнесПроцесс <> Неопределено Тогда
		КартаМаршрута = БизнесПроцессы[БизнесПроцесс.Метаданные().Имя].ПолучитьКартуМаршрута();
	Иначе
		КартаМаршрута = Новый ГрафическаяСхема;
	КонецЕсли;
	
	КартаМаршрута.ВертикальныйШагСетки		= 10;
	КартаМаршрута.ГоризонтальныйШагСетки	= 10;

КонецПроцедуры

&НаКлиенте
Процедура ОткрытьСписокЗадачТочкиМаршрута()
	
	ОчиститьСообщения();
	ТекЭлемент = Элементы.КартаМаршрута.ТекущийЭлемент;

	Если НЕ ЗначениеЗаполнено(БизнесПроцесс) Тогда
		ПредупреждениеСообщение(, "Необходимо указать бизнес-процесс.");
		Возврат;
	КонецЕсли;
	
	Если ТекЭлемент = Неопределено ИЛИ
		НЕ (ТипЗнч(ТекЭлемент) = Тип("ЭлементГрафическойСхемыДействие")
		ИЛИ ТипЗнч(ТекЭлемент) = Тип("ЭлементГрафическойСхемыВложенныйБизнесПроцесс")) Тогда
		
			ПредупреждениеСообщение(, "Необходимо выбрать точку действия или вложенный бизнес-процесс карты маршрута.");
		
		Возврат;
	КонецЕсли;

	ЗаголовокФормы = ("Задачи точки маршрута бизнес-процесса");
		
	ОткрытьФорму("Задача." + ПолучитьИмяЗадачиИзМетаданныхНаСервере() + ".ФормаСписка", 
		Новый Структура("Отбор,ЗаголовокФормы,ПоказыватьЗадачи,ВидимостьОтборов,БлокировкаОкнаВладельца,Задача,БизнесПроцесс", 
			Новый Структура("БизнесПроцесс,ТочкаМаршрута", БизнесПроцесс, ТекЭлемент.Значение),
			ЗаголовокФормы,0,Ложь,РежимОткрытияОкнаФормы.БлокироватьОкноВладельца,Строка(ТекЭлемент.Значение),Строка(БизнесПроцесс)),
		ЭтаФорма, БизнесПроцесс);

КонецПроцедуры

&НаСервере
Функция ПолучитьИмяЗадачиИзМетаданныхНаСервере()
	
	Возврат БизнесПроцесс.Метаданные().Задача.Имя;
	
КонецФункции

&НаКлиенте
Процедура ПредупреждениеСообщение(Оповещение, ТекстПредупрежденияСообщения, Таймаут = 0, Заголовок = "")
	
	Если ИспользоватьРежимМодальности() Тогда
		// Стандартно в модальном режиме (8.2/8.3) с обработкой результата.
		Предупреждение(ТекстПредупрежденияСообщения, Таймаут, Заголовок);
	Иначе
		// Стандартно в немодальном режиме (8.3) с обработкой результата.
		Выполнить("ПоказатьПредупреждение(Оповещение, ТекстПредупрежденияСообщения, Таймаут, Заголовок)");
	КонецЕсли;;
		
КонецПроцедуры

&НаКлиенте
Функция ИспользоватьРежимМодальности()
	Возврат РежимИспользованияМодальностиБулево;
КонецФункции
