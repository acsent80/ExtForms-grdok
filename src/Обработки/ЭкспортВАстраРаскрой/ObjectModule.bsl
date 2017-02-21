﻿#Область ПрограмныйИнтерфейс

Функция СведенияОВнешнейОбработке() Экспорт
	
	ПараметрыРегистрации = Новый Структура;
	
	ПараметрыРегистрации.Вставить("Вид",             "ДополнительнаяОбработка");
	ПараметрыРегистрации.Вставить("Наименование",    Метаданные().Представление());
	ПараметрыРегистрации.Вставить("Версия",          Метаданные().Комментарий);
	ПараметрыРегистрации.Вставить("БезопасныйРежим", Ложь);
	ПараметрыРегистрации.Вставить("Информация",      Метаданные().Представление());
	
	ТаблицаКоманд = ПолучитьТаблицуКоманд();
	
	ДобавитьКоманду(ТаблицаКоманд,
	ПараметрыРегистрации.Наименование,
	"ОткрытьОбработку",
	"ОткрытиеФормы",
	Истина);
	
	ПараметрыРегистрации.Вставить("Команды", ТаблицаКоманд);
	
	Возврат ПараметрыРегистрации;
	
КонецФункции

Функция ПолучитьТаблицуКоманд()
	Команды = Новый ТаблицаЗначений;
	Команды.Колонки.Добавить("Представление", Новый ОписаниеТипов("Строка"));
	Команды.Колонки.Добавить("Идентификатор", Новый ОписаниеТипов("Строка"));
	Команды.Колонки.Добавить("Использование", Новый ОписаниеТипов("Строка"));
	Команды.Колонки.Добавить("ПоказыватьОповещение", Новый ОписаниеТипов("Булево"));
	Команды.Колонки.Добавить("Модификатор", Новый ОписаниеТипов("Строка"));
	Возврат Команды;
КонецФункции

Процедура ДобавитьКоманду(ТаблицаКоманд, Представление, Идентификатор, Использование, ПоказыватьОповещение = Ложь, Модификатор = "")
	
	НоваяКоманда = ТаблицаКоманд.Добавить();
	НоваяКоманда.Представление = Представление;
	НоваяКоманда.Идентификатор = Идентификатор;
	НоваяКоманда.Использование = Использование;
	НоваяКоманда.ПоказыватьОповещение = ПоказыватьОповещение;
	НоваяКоманда.Модификатор = Модификатор;
	
КонецПроцедуры

#КонецОбласти

Функция ПолучитьОстатки(Номенклатура, Склад) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Параметры.Вставить("Номенклатура", Номенклатура);
	Запрос.Параметры.Вставить("Склад",        Склад);
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Рег.Номенклатура КАК Номенклатура,
	|	Рег.Характеристика КАК Характеристика,
	|	Рег.ВНаличииОстаток КАК Количество
	|ИЗ
	|	РегистрНакопления.ТоварыНаСкладах.Остатки(
	|			,
	|			Номенклатура В (&Номенклатура)
	|				И Склад = &Склад) КАК Рег
	|
	|УПОРЯДОЧИТЬ ПО
	|	Номенклатура,
	|	Характеристика";
	
	Таблица = Запрос.Выполнить().Выгрузить();
	Возврат Таблица;
	
КонецФункции	

Функция ВыгрузитьОстатки() Экспорт
	
	Свойства = Новый Структура;
	Свойства.Вставить("Наименование", ПланыВидовХарактеристик.ДополнительныеРеквизитыИСведения.НайтиПоНаименованию("Описание товара RUS (Номенклатура)"));
	
	Свойства.Вставить("Длина",    ПланыВидовХарактеристик.ДополнительныеРеквизитыИСведения.НайтиПоНаименованию("1. Длина (Характеристики номенклатуры)"));
	Свойства.Вставить("Ширина",   ПланыВидовХарактеристик.ДополнительныеРеквизитыИСведения.НайтиПоНаименованию("2. Ширина (Характеристики номенклатуры)"));
	Свойства.Вставить("Толщина",  ПланыВидовХарактеристик.ДополнительныеРеквизитыИСведения.НайтиПоНаименованию("3. Толщина (Характеристики номенклатуры)"));
	Свойства.Вставить("Радиус",   ПланыВидовХарактеристик.ДополнительныеРеквизитыИСведения.НайтиПоНаименованию("4. Радиус (Характеристики номенклатуры)"));
	Свойства.Вставить("Покрытие", ПланыВидовХарактеристик.ДополнительныеРеквизитыИСведения.НайтиПоНаименованию("5 Покрытие (Характеристики номенклатуры)"));
	Свойства.Вставить("Сорт",     ПланыВидовХарактеристик.ДополнительныеРеквизитыИСведения.НайтиПоНаименованию("6 Сорт (Характеристики номенклатуры)"));
	
	Свойства.Вставить("ДлинаЧислом",    ПланыВидовХарактеристик.ДополнительныеРеквизитыИСведения.НайтиПоНаименованию("1 Длина числом (Характеристики номенклатуры)"));
	Свойства.Вставить("ШиринаЧислом",   ПланыВидовХарактеристик.ДополнительныеРеквизитыИСведения.НайтиПоНаименованию("2 Ширина числом (Характеристики номенклатуры)"));
	Свойства.Вставить("ТолщинаЧислом",  ПланыВидовХарактеристик.ДополнительныеРеквизитыИСведения.НайтиПоНаименованию("3 Толщина числом (Характеристики номенклатуры)"));
	Свойства.Вставить("РадиусЧислом",   ПланыВидовХарактеристик.ДополнительныеРеквизитыИСведения.НайтиПоНаименованию("4 Радиус числом (Характеристики номенклатуры)"));
	
	Номенклатура = Новый Массив;
	Для каждого ЭлементСписка из НоменклатураЛистыОтмеченные Цикл
		Номенклатура.Добавить(ЭлементСписка.Значение);
	КонецЦикла;	
	Для каждого ЭлементСписка из НоменклатураОстаткиОтмеченные Цикл
		Номенклатура.Добавить(ЭлементСписка.Значение);
	КонецЦикла;	
	
	ТаблицаОстатков.Загрузить(ПолучитьОстатки(Номенклатура, Склад));
	
	ИмяФайлаXML = ПолучитьИмяВременногоФайла("xml");
	ЗаписьXML = Новый ЗаписьXML;
	ЗаписьXML.ОткрытьФайл(ИмяФайлаXML);
	
	ЗаписьXML.ЗаписатьНачалоЭлемента("data");
	ЗаписьXML.ЗаписатьАтрибут("stock_plate_resete",  "1");
	ЗаписьXML.ЗаписатьАтрибут("stock_rest_resete",   "1");
	
	ЗаписьXML.ЗаписатьНачалоЭлемента("data_sheet");
	ЗаписьXML.ЗаписатьНачалоЭлемента("list_materials");
	
	ПредНоменклатура = Неопределено;
	Для каждого Строка1 из ТаблицаОстатков Цикл
		
		ЗначенияСвойств = ПолучитьЗначениеСвойств(Строка1.Номенклатура, Строка1.Характеристика, Свойства);
		Строка1.КоличествоЛистов = ПолучитьКоличествоЛистов(Строка1.Номенклатура, Строка1.Характеристика, ЗначенияСвойств, Строка1.Количество);
		
		Если НЕ ЗначениеЗаполнено(ЗначенияСвойств.Толщина)
			ИЛИ Строка1.КоличествоЛистов = 0 Тогда
			
			Строка1.НеВыгружать = Истина;
			Продолжить;
			
		КонецЕсли;	
		
		ТекНоменклатура = ПолучитьНаименованиеНоменклатуры(Строка1.Номенклатура, Строка1.Характеристика, ЗначенияСвойств);
		
		Если ТекНоменклатура <> ПредНоменклатура Тогда
			
			Если ПредНоменклатура <> Неопределено Тогда
				ЗаписьXML.ЗаписатьКонецЭлемента(); // list_sheets
				ЗаписьXML.ЗаписатьКонецЭлемента(); // material
			КонецЕсли;	
			
			ЗаписьXML.ЗаписатьНачалоЭлемента("material");
			ЗаписьXML.ЗаписатьАтрибут("name",    ТекНоменклатура);
			ЗаписьXML.ЗаписатьАтрибут("wid_cut", Формат(ШиринраРеза, "ЧРД=.; ЧГ=0"));
			
			КромкаСтр = "0;0;" + Формат(Кромка, "ЧРД=.; ЧГ=0") + ";" + Формат(Кромка, "ЧРД=.; ЧГ=0");
			ЗаписьXML.ЗаписатьАтрибут("sheet_border", КромкаСтр);
			ЗаписьXML.ЗаписатьАтрибут("rest_border",  КромкаСтр);
			
			ЗаписьXML.ЗаписатьАтрибут("rest_size",  Формат(МинОстатокДлина, "ЧРД=.; ЧГ=0") + ";" + Формат(МинОстатокШирина, "ЧРД=.; ЧГ=0"));
		
			ЗаписьXML.ЗаписатьНачалоЭлемента("list_sheets");
			
			ПредНоменклатура = ТекНоменклатура;
			
		КонецЕсли;	
		
		Строка1.КоличествоЛистов = ПолучитьКоличествоЛистов(Строка1.Номенклатура, Строка1.Характеристика, ЗначенияСвойств, Строка1.Количество);
		
		ЗаписьXML.ЗаписатьНачалоЭлемента("sheet");
		ЗаписьXML.ЗаписатьАтрибут("length",   Формат(ЗначенияСвойств.Длина, "ЧН=0; ЧГ=0"));
		ЗаписьXML.ЗаписатьАтрибут("width",    Формат(ЗначенияСвойств.Ширина, "ЧН=0; ЧГ=0"));
		ЗаписьXML.ЗаписатьАтрибут("thick",    Формат(ЗначенияСвойств.Толщина, "ЧН=0; ЧГ=0"));
		ЗаписьXML.ЗаписатьАтрибут("quantity", Формат(Строка1.КоличествоЛистов, "ЧГ=0"));
		
		Если НоменклатураЛистыОтмеченные.НайтиПоЗначению(Строка1.Номенклатура) <> Неопределено Тогда
			ЗаписьXML.ЗаписатьАтрибут("type", "0");
		Иначе	
			ЗаписьXML.ЗаписатьАтрибут("type", "1");
		КонецЕсли;
		
		ЗаписьXML.ЗаписатьКонецЭлемента(); // sheet
			
	КонецЦикла;
	
	Если ПредНоменклатура <> Неопределено Тогда
		ЗаписьXML.ЗаписатьКонецЭлемента(); // list_sheets
		ЗаписьXML.ЗаписатьКонецЭлемента(); // material
	КонецЕсли;	
	
	ЗаписьXML.ЗаписатьКонецЭлемента(); // list_materials
	ЗаписьXML.ЗаписатьКонецЭлемента(); // data_sheet
	ЗаписьXML.ЗаписатьКонецЭлемента(); // data
	
	ЗаписьXML.Закрыть();
	
	Возврат ИмяФайлаXML;
	
КонецФункции

Функция Выгрузить() Экспорт
	
	ИмяФайлаXML = ВыгрузитьОстатки();
	Возврат ИмяФайлаXML;
	
КонецФункции	

Функция ПолучитьЗначениеСвойств(Номенклатура, Характеристика, Свойства)
	
	ЗначенияСвойств = Новый Структура;
	
	ЗначенияСвойств.Вставить("Наименование", _ОбщегоНазначенияДоп.ПолучитьДопРеквизит(Номенклатура, Свойства.Наименование));
	
	ЗначенияСвойств.Вставить("Длина",     _ОбщегоНазначенияДоп.ПолучитьДопРеквизит(Характеристика, Свойства.Длина));
	ЗначенияСвойств.Вставить("Ширина",    _ОбщегоНазначенияДоп.ПолучитьДопРеквизит(Характеристика, Свойства.Ширина));
	ЗначенияСвойств.Вставить("Толщина",   _ОбщегоНазначенияДоп.ПолучитьДопРеквизит(Характеристика, Свойства.Толщина));
	ЗначенияСвойств.Вставить("Радиус",    _ОбщегоНазначенияДоп.ПолучитьДопРеквизит(Характеристика, Свойства.Радиус));
	
	Если ЗначениеЗаполнено(ЗначенияСвойств.Длина) Тогда
		ЗначенияСвойств.Вставить("Длина",     Число(Строка(ЗначенияСвойств.Длина)));
	Иначе	
		ЗначенияСвойств.Вставить("Длина",     _ОбщегоНазначенияДоп.ПолучитьДопРеквизит(Характеристика, Свойства.ДлинаЧислом));
	КонецЕсли;	
	
	Если ЗначениеЗаполнено(ЗначенияСвойств.Ширина) Тогда
		ЗначенияСвойств.Вставить("Ширина",     Число(Строка(ЗначенияСвойств.Ширина)));
	Иначе	
		ЗначенияСвойств.Вставить("Ширина",     _ОбщегоНазначенияДоп.ПолучитьДопРеквизит(Характеристика, Свойства.ШиринаЧислом));
	КонецЕсли;	
	
	Если ЗначениеЗаполнено(ЗначенияСвойств.Толщина) Тогда
		ЗначенияСвойств.Вставить("Толщина",     Число(Строка(ЗначенияСвойств.Толщина)));
	Иначе	
		ЗначенияСвойств.Вставить("Толщина",     _ОбщегоНазначенияДоп.ПолучитьДопРеквизит(Характеристика, Свойства.ТолщинаЧислом));
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ЗначенияСвойств.Радиус) Тогда
		ЗначенияСвойств.Вставить("Радиус",     Число(Строка(ЗначенияСвойств.Радиус)));
	Иначе	
		ЗначенияСвойств.Вставить("Радиус",     _ОбщегоНазначенияДоп.ПолучитьДопРеквизит(Характеристика, Свойства.РадиусЧислом));
	КонецЕсли;	
	
	ЗначенияСвойств.Вставить("Покрытие",  _ОбщегоНазначенияДоп.ПолучитьДопРеквизит(Характеристика, Свойства.Покрытие));
	ЗначенияСвойств.Вставить("Сорт",      _ОбщегоНазначенияДоп.ПолучитьДопРеквизит(Характеристика, Свойства.Сорт));
		
	Возврат ЗначенияСвойств;
	
КонецФункции

Функция ПолучитьНаименованиеНоменклатуры(Номенклатура, Характеристика, ЗначенияСвойств) Экспорт
	
	//Если СокрЛП(Номенклатура.Код) = "00000000017" Тогда // Блок (CV полуфабрикат - склейка)
	//	
	Сорт = ЗначенияСвойств.Сорт;
	Если НЕ ЗначениеЗаполнено(Сорт) Тогда
		Сорт = СортПоУмолчанию;
	КонецЕсли;	
	
	Наименование = ЗначенияСвойств.Наименование + " " + Формат(ЗначенияСвойств.Радиус, "ЧГ=0") + ", " + СокрЛП(ЗначенияСвойств.Покрытие) + ", " + СокрЛП(Сорт);
		
	//Иначе
	//	Наименование = СокрЛП(Номенклатура);
	//КонецЕсли;	
	
	Возврат Наименование;
	
КонецФункции

Функция ПолучитьКоличествоЛистов(Номенклатура, Характеристика, ЗначенияСвойств, Количество)
	
	Попытка
		Возврат Цел(Количество / ((ЗначенияСвойств.Длина/1000) * (ЗначенияСвойств.Ширина/1000) * (ЗначенияСвойств.Толщина/1000)));
	Исключение
		Возврат 0;
	КонецПопытки;	
	
КонецФункции

