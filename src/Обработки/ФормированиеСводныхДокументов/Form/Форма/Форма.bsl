﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Объект.Период = НачалоМесяца(НачалоМесяца(ТекущаяДата()) - 1);
	СворачиватьДокументыПередача = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ПредставлениеПериодаРегистрации = ОбщегоНазначенияУТКлиент.ПолучитьПредставлениеПериодаРегистрации(Объект.Период);
	
КонецПроцедуры

#КонецОбласти

#Область ОбщиеПроцедуры

&НаКлиенте
Процедура ПредставлениеПериодаРегистрацииНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	Оповещение = Новый ОписаниеОповещения("ПредставлениеПериодаРегистрацииНачалоВыбораЗавершение", ЭтотОбъект);
	ОбщегоНазначенияУТКлиент.НачалоВыбораПредставленияПериодаРегистрации(Элемент,
		СтандартнаяОбработка,
		Объект.Период,
		ЭтаФорма,
		Оповещение);
КонецПроцедуры

&НаКлиенте
Процедура ПредставлениеПериодаРегистрацииНачалоВыбораЗавершение(ВыбранныйПериод, ДополнительныеПараметры) Экспорт 
	Если ВыбранныйПериод <> Неопределено Тогда
		Объект.Период = ВыбранныйПериод;
		ПредставлениеПериодаРегистрации = ОбщегоНазначенияУТКлиент.ПолучитьПредставлениеПериодаРегистрации(Объект.Период);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПредставлениеПериодаРегистрацииРегулирование(Элемент, Направление, СтандартнаяОбработка)
	ОбщегоНазначенияУТКлиент.РегулированиеПредставленияПериодаРегистрации(Направление,
		СтандартнаяОбработка,
		Объект.Период,
		ПредставлениеПериодаРегистрации);
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ОчиститьДвиженияПоРегистрам(Ссылка, МассивРегистров)
	
	Запрос = Новый Запрос;
	Запрос.Параметры.Вставить("Регистратор", Ссылка);
	
	ТекстЗапроса =
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	Рег.Период
	|ИЗ
	|	РегистрНакопления.БонусныеБаллы КАК Рег
	|ГДЕ
	|	Рег.Регистратор = &Регистратор";
	
	Для каждого ИмяРегистра из МассивРегистров Цикл
		
		Запрос.Текст = СтрЗаменить(ТекстЗапроса, "БонусныеБаллы", ИмяРегистра);
		
		Результат = Запрос.Выполнить();
		Если НЕ Результат.Пустой() Тогда
			
			НаборЗаписей = РегистрыНакопления[ИмяРегистра].СоздатьнаборЗаписей();
			НаборЗаписей.Отбор.Регистратор.Установить(Ссылка);
			
			Попытка
				НаборЗаписей.Записать(Истина);
			Исключение
			КонецПопытки;	
			
		КонецЕсли;	
		
	КонецЦикла;	
	
КонецПроцедуры	

&НаСервереБезКонтекста
Функция ОтменитьДокументыИПровестиСводный(СводныйДокументОбъект, ТаблицаСсылок) Экспорт
	
	МетаданныеДокумента  = СводныйДокументОбъект.Метаданные();
	КоличествоДокументов = ТаблицаСсылок.Количество();
	
	ВремяНачала = ТекущаяДата();
	
	ЗаписьЖурналаРегистрации("Формирование сводных документов", УровеньЖурналаРегистрации.Информация,
		МетаданныеДокумента,
		СводныйДокументОбъект.Ссылка,
		"Очистка регистров. " + КоличествоДокументов + " документов");
		
	//Очистим регистр "ПартииЗатратНаВыпуск"
	МассивРегистров = Новый Массив;
	МассивРегистров.Добавить(Метаданные.РегистрыНакопления.ПартииПроизводственныхЗатрат.Имя);
	МассивРегистров.Добавить(Метаданные.РегистрыНакопления.ПартииЗатратНаВыпуск.Имя);
	МассивРегистров.Добавить(Метаданные.РегистрыНакопления.ПартииТоваровОрганизаций.Имя);
	МассивРегистров.Добавить(Метаданные.РегистрыНакопления.МатериалыИРаботыВПроизводстве.Имя);
	МассивРегистров.Добавить(Метаданные.РегистрыНакопления.ДвиженияНоменклатураНоменклатура.Имя);
	МассивРегистров.Добавить(Метаданные.РегистрыНакопления.ДвижениеТоваров.Имя);
	
	Для каждого СтрокаТЗ из ТаблицаСсылок Цикл
		ОчиститьДвиженияПоРегистрам(СтрокаТЗ.Ссылка, МассивРегистров);
	КонецЦикла;	
	
	ЗаписьЖурналаРегистрации("Формирование сводных документов", УровеньЖурналаРегистрации.Информация,
		МетаданныеДокумента,
		СводныйДокументОбъект.Ссылка,
		"Отмена проведения " + КоличествоДокументов + " документов");
		
	Попытка
		
		НачатьТранзакцию();
		
		Блокировка = Новый БлокировкаДанных;
		
		ЭлементБлокировки = Блокировка.Добавить("Документ." + МетаданныеДокумента.Имя);
		ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
		ЭлементБлокировки.УстановитьЗначение("Ссылка", СводныйДокументОбъект.Ссылка);
		
		ЭлементБлокировки = Блокировка.Добавить("Документ." + МетаданныеДокумента.Имя);
		ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
		ЭлементБлокировки.ИсточникДанных = ТаблицаСсылок;
		ЭлементБлокировки.ИспользоватьИзИсточникаДанных("Ссылка", "Ссылка");
		
		Блокировка.Заблокировать();
		
		Счетчик = 0;
		Для каждого СтрокаТЗ из ТаблицаСсылок Цикл
			
			Счетчик = Счетчик + 1;
			
			ДокументКУдалению = СтрокаТЗ.Ссылка.ПолучитьОбъект();
			
			Комментарий = ДокументКУдалению.Комментарий;
			Если Найти(Комментарий, "Перенесен в сводный") = 0 Тогда
				
				ДокументКУдалению.Комментарий = "Перенесен в сводный";
				Если ЗначениеЗаполнено(Комментарий) Тогда
					ДокументКУдалению.Комментарий = ДокументКУдалению.Комментарий + ", " + Комментарий;
				КонецЕсли;
				
			КонецЕсли;
			
			ДокументКУдалению.Записать(РежимЗаписиДокумента.ОтменаПроведения);
			
			Если Счетчик % 100 = 0 Тогда
				
				ЗаписьЖурналаРегистрации("Формирование сводных документов", УровеньЖурналаРегистрации.Информация,
					МетаданныеДокумента,
					СводныйДокументОбъект.Ссылка,
					"Отменено " + Счетчик + " документов");
					
			КонецЕсли;	
			
		КонецЦикла;	
		СводныйДокументОбъект.Записать(РежимЗаписиДокумента.Проведение);
		
		ЗаписьЖурналаРегистрации("Формирование сводных документов", УровеньЖурналаРегистрации.Информация,
			МетаданныеДокумента,
			СводныйДокументОбъект.Ссылка,
			"Начало фиксации транзакции");
			
		ЗафиксироватьТранзакцию();
		
	Исключение	
		
		ОтменитьТранзакцию();
		ЗаписьЖурналаРегистрации("Формирование сводных документов", УровеньЖурналаРегистрации.Ошибка,
			МетаданныеДокумента,
			СводныйДокументОбъект.Ссылка,
			ОписаниеОшибки());
			
		Возврат 0;
		
	КонецПопытки;
	
	ВремяВыполнения = ТекущаяДата() - ВремяНачала;
	
	ЗаписьЖурналаРегистрации("Формирование сводных документов", УровеньЖурналаРегистрации.Информация,
		МетаданныеДокумента,
		СводныйДокументОбъект.Ссылка,
		"Документ сформирован за " + ВремяВыполнения + " с. Помечено " + КоличествоДокументов + " документов");
		
	Возврат 2;
	
КонецФункции	

#КонецОбласти

#Область ВыпускПродукции

&НаКлиенте
Процедура ВыпускВклВсе(Команда)
	
	Для каждого СтрокаТЗ из ТаблицаВыпускПродукции Цикл
		СтрокаТЗ.Пометка = Истина;
	КонецЦикла;	
	
КонецПроцедуры

&НаКлиенте
Процедура ВыпускВыклВсе(Команда)
	
	Для каждого СтрокаТЗ из ТаблицаВыпускПродукции Цикл
		СтрокаТЗ.Пометка = Ложь;
	КонецЦикла;	
	
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаВыпускПродукцииВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтрокаТЗ = ТаблицаВыпускПродукции.НайтиПоИдентификатору(ВыбраннаяСтрока);
	
	Если Поле.Имя = "ТаблицаВыпускПродукцииСводныйДокумент" Тогда
		
		ПоказатьЗначение(, СтрокаТЗ.СводныйДокумент);
		
	Иначе
		
		Форма = ОткрытьФорму("Документ.ВыпускПродукции.ФормаСписка");
		Форма.Элементы.ГруппаСтраницы.ТекущаяСтраница = Форма.Элементы.ГруппаВыпускПродукции;
		Форма.ОтборПодразделениеОтправитель = СтрокаТЗ.Подразделение;
		
		Форма.Элементы.Список.Период.ДатаНачала    = НачалоМесяца(Объект.Период);
		Форма.Элементы.Список.Период.ДатаОкончания = КонецМесяца(Объект.Период);

		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
			Форма.Список,
			"Подразделение",
			СтрокаТЗ.Подразделение,
			ВидСравненияКомпоновкиДанных.Равно,,
			Истина);
			
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура ВыпускЗаполнить(Команда)
	ВыпускЗаполнитьНаСервере();
КонецПроцедуры

&НаСервере
Процедура ВыпускЗаполнитьНаСервере()
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Выборка.Месяц КАК Месяц,
	|	Выборка.Организация КАК Организация,
	|	Выборка.Подразделение КАК Подразделение,
	|	Выборка.Склад КАК Склад,
	|	Выборка.НаправлениеВыпуска КАК НаправлениеВыпуска,
	|	Выборка.КоличествоДокументов КАК КоличествоДокументов,
	|	Док.Ссылка КАК СводныйДокумент
	|ИЗ
	|	(ВЫБРАТЬ
	|		НАЧАЛОПЕРИОДА(Док.Дата, МЕСЯЦ) КАК Месяц,
	|		Док.Организация КАК Организация,
	|		Док.Подразделение КАК Подразделение,
	|		Док.Склад КАК Склад,
	|		Док.НаправлениеВыпуска КАК НаправлениеВыпуска,
	|		КОЛИЧЕСТВО(Док.Ссылка) КАК КоличествоДокументов
	|	ИЗ
	|		Документ.ВыпускПродукции КАК Док
	|	ГДЕ
	|		Док.Дата МЕЖДУ &Дата1 И &Дата2
	|		И Док.Проведен
	|		И (Док.Распоряжение <> ЗНАЧЕНИЕ(Документ.МаршрутныйЛистПроизводства.ПустаяСсылка)
	|				ИЛИ Док.Комментарий ПОДОБНО ""Сводный выпуск%"")
	|		И Док.Организация = &Организация
	|	
	|	СГРУППИРОВАТЬ ПО
	|		НАЧАЛОПЕРИОДА(Док.Дата, МЕСЯЦ),
	|		Док.Организация,
	|		Док.НаправлениеВыпуска,
	|		Док.Склад,
	|		Док.Подразделение) КАК Выборка
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ВыпускПродукции КАК Док
	|		ПО (Выборка.Месяц = НАЧАЛОПЕРИОДА(Док.Дата, МЕСЯЦ))
	|			И Выборка.Организация = Док.Организация
	|			И Выборка.Подразделение = Док.Подразделение
	|			И Выборка.НаправлениеВыпуска = Док.НаправлениеВыпуска
	|			И Выборка.Склад = Док.Склад
	|			И (Док.Комментарий ПОДОБНО ""Сводный выпуск%"")
	|
	|УПОРЯДОЧИТЬ ПО
	|	Подразделение,
	|	Склад
	|АВТОУПОРЯДОЧИВАНИЕ";
	
	Запрос.Параметры.Вставить("Дата1",       НачалоМесяца(Объект.Период));
	Запрос.Параметры.Вставить("Дата2",       КонецМесяца(Объект.Период));
	Запрос.Параметры.Вставить("Организация", Объект.Организация);
	
	Таблица = Запрос.Выполнить().Выгрузить();
	
	ТаблицаВыпускПродукции.Загрузить(Таблица);
	Для каждого СтрокаТЗ из ТаблицаВыпускПродукции Цикл
		
		Если СтрокаТЗ.КоличествоДокументов = 1 Тогда
			СтрокаТЗ.Результат = 2;
		Иначе
			СтрокаТЗ.Результат = 1;
			СтрокаТЗ.Пометка   = Истина;
		КонецЕсли;	
			
	КонецЦикла;	
	
КонецПроцедуры

&НаКлиенте
Процедура ВыпускСформироватьДокументы(Команда)
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ВыпускСформироватьДокументыОтвет", ЭтотОбъект);
	ПоказатьВопрос(ОписаниеОповещения, "Сформировать документы?", РежимДиалогаВопрос.ДаНет, 60);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыпускСформироватьДокументыОтвет(Ответ, ДополнительныеПараметры) Экспорт
	
	Если Ответ <> КодВозвратаДиалога.Да Тогда
		Возврат;
	КонецЕсли;	
	
	Для каждого СтрокаТЗ из ТаблицаВыпускПродукции Цикл
		
		Если СтрокаТЗ.Пометка Тогда
			
			Состояние("" + СтрокаТЗ.Подразделение + " / " + СтрокаТЗ.Склад);
			
			ПараметрыДокумента = Новый Структура;
			ПараметрыДокумента.Вставить("Месяц",              СтрокаТЗ.Месяц);
			ПараметрыДокумента.Вставить("Организация",        СтрокаТЗ.Организация);
			ПараметрыДокумента.Вставить("Подразделение",      СтрокаТЗ.Подразделение);
			ПараметрыДокумента.Вставить("Склад",              СтрокаТЗ.Склад);
			ПараметрыДокумента.Вставить("НаправлениеВыпуска", СтрокаТЗ.НаправлениеВыпуска);
			ПараметрыДокумента.Вставить("КоличествоДокументов", СтрокаТЗ.КоличествоДокументов);
			
			СтрокаТЗ.Результат = ВыпускСформироватьСводыйДокумент(ПараметрыДокумента, СтрокаТЗ.СводныйДокумент);
			Если СтрокаТЗ.Результат = 2 Тогда
				СтрокаТЗ.КоличествоДокументов = 1;
			КонецЕсли;	
			
			ОчиститьСообщения();
			ОбновитьОтображениеДанных(Элементы.ТаблицаВыпускПродукции);
			ОбработкаПрерыванияПользователя();
			
		КонецЕсли;
		
	КонецЦикла;	
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ВыпускСформироватьСводыйДокумент(Знач ПараметрыДокумента, СводныйДокумент) Экспорт
	
	Если ПараметрыДокумента.КоличествоДокументов = 1 Тогда
		Возврат 2;
	КонецЕсли;	
	
	ВремяНачала = ТекущаяДата();
	
	Если ЗначениеЗаполнено(СводныйДокумент) Тогда
		ДокументОбъект = СводныйДокумент.ПолучитьОбъект();
	Иначе
		ДокументОбъект = Документы.ВыпускПродукции.СоздатьДокумент();
		ДокументОбъект.Дата               = НачалоДня(КонецМесяца(ПараметрыДокумента.Месяц));
		ДокументОбъект.Организация        = ПараметрыДокумента.Организация;
		ДокументОбъект.Подразделение      = ПараметрыДокумента.Подразделение;
		ДокументОбъект.Склад              = ПараметрыДокумента.Склад;
		ДокументОбъект.НаправлениеВыпуска = ПараметрыДокумента.НаправлениеВыпуска;
		ДокументОбъект.Комментарий        = "Сводный выпуск";
	КонецЕсли;
	
	ДокументОбъект.ВыпускПоРаспоряжениям = Истина;
	ДокументОбъект.ВыпускПодДеятельность = Перечисления.ТипыНалогообложенияНДС.ПродажаОблагаетсяНДС;
	ДокументОбъект.Ответственный         = Пользователи.ТекущийПользователь();
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Док.Ссылка КАК Ссылка,
	|	ВЫБОР
	|		КОГДА Док.Распоряжение = ЗНАЧЕНИЕ(Документ.МаршрутныйЛистПроизводства.ПустаяСсылка)
	|			ТОГДА Док.Ссылка.Распоряжение
	|		ИНАЧЕ Док.Распоряжение
	|	КОНЕЦ КАК Распоряжение,
	|	Док.Номенклатура,
	|	Док.Характеристика,
	|	Док.Спецификация,
	|	Док.Упаковка,
	|	Док.КоличествоУпаковок КАК КоличествоУпаковок,
	|	Док.Количество КАК Количество,
	|	Док.Цена,
	|	Док.Сумма КАК Сумма,
	|	Док.ТипСтоимости,
	|	Док.СтатусУказанияСерий,
	|	Док.КодСтроки,
	|	Док.Серия,
	|	Док.Назначение,
	|	Док.СтатьяРасходов,
	|	Док.АналитикаРасходов,
	|	Док.СписатьНаРасходы,
	|	ВЫБОР
	|		КОГДА Док.Склад = ЗНАЧЕНИЕ(Справочник.Склады.ПустаяСсылка)
	|			ТОГДА Док.Ссылка.Склад
	|		ИНАЧЕ Док.Склад
	|	КОНЕЦ КАК Склад,
	|	Док.Подразделение,
	|	Док.Калькуляция
	|ИЗ
	|	Документ.ВыпускПродукции.Товары КАК Док
	|ГДЕ
	|	Док.Ссылка.Дата МЕЖДУ &Дата1 И &Дата2
	|	И Док.Ссылка.Проведен
	|	И Док.Ссылка.Организация = &Организация
	|	И Док.Ссылка.Подразделение = &Подразделение
	|	И Док.Ссылка.Склад = &Склад
	|	И Док.Ссылка.НаправлениеВыпуска = &НаправлениеВыпуска
	|	И (Док.Ссылка.Распоряжение <> ЗНАЧЕНИЕ(Документ.МаршрутныйЛистПроизводства.ПустаяСсылка)
	|			ИЛИ Док.Ссылка.Комментарий ПОДОБНО &Комментарий)";
	
	Запрос.Параметры.Вставить("Дата1",              НачалоМесяца(ПараметрыДокумента.Месяц));
	Запрос.Параметры.Вставить("Дата2",              КонецМесяца(ПараметрыДокумента.Месяц));
	Запрос.Параметры.Вставить("Организация",        ПараметрыДокумента.Организация);
	Запрос.Параметры.Вставить("Подразделение",      ПараметрыДокумента.Подразделение);
	Запрос.Параметры.Вставить("Склад",              ПараметрыДокумента.Склад);
	Запрос.Параметры.Вставить("НаправлениеВыпуска", ПараметрыДокумента.НаправлениеВыпуска);
	Запрос.Параметры.Вставить("Комментарий",        "Сводный выпуск%");
	
	ТаблицаДокумента = Запрос.Выполнить().Выгрузить();
	Если ТаблицаДокумента.Количество() = 0 Тогда
		// Документов нет, выходим
		Возврат 2;
	КонецЕсли;	
	
	ТаблицаСсылок = ТаблицаДокумента.Скопировать(, "Ссылка");
	ТаблицаСсылок.Свернуть("Ссылка");
	
	ДокументОбъект.Товары.Загрузить(ТаблицаДокумента);
	
	ДокументОбъект.Записать();
	СводныйДокумент = ДокументОбъект.Ссылка;
	
	Результат = ОтменитьДокументыИПровестиСводный(ДокументОбъект, ТаблицаСсылок);
	Возврат Результат;
	
КонецФункции	

#КонецОбласти

#Область ПередачаМатериаловВпроизводство

&НаКлиенте
Процедура ПередачаВклВсе(Команда)
	
	Для каждого СтрокаТЗ из ТаблицаПередачаВПроизводство Цикл
		СтрокаТЗ.Пометка = Истина;
	КонецЦикла;	
	
КонецПроцедуры

&НаКлиенте
Процедура ПередачаВыклВсе(Команда)
	
	Для каждого СтрокаТЗ из ТаблицаПередачаВПроизводство Цикл
		СтрокаТЗ.Пометка = Ложь;
	КонецЦикла;	
	
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаПередачаВПроизводствоВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтрокаТЗ = ТаблицаПередачаВПроизводство.НайтиПоИдентификатору(ВыбраннаяСтрока);
	Если Поле.Имя = "ТаблицаПередачаВПроизводствоСводныйДокумент" Тогда
		
		ПоказатьЗначение(, СтрокаТЗ.СводныйДокумент);
		
	Иначе
		
		Форма = ОткрытьФорму("Документ.ПередачаМатериаловВПроизводство.ФормаСписка");
		
		Форма.Элементы.Список.Период.ДатаНачала    = НачалоМесяца(Объект.Период);
		Форма.Элементы.Список.Период.ДатаОкончания = КонецМесяца(Объект.Период);

		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
			Форма.Список,
			"Подразделение",
			СтрокаТЗ.Подразделение,
			ВидСравненияКомпоновкиДанных.Равно,,
			Истина);
			
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура ПередачаЗаполнить(Команда)
	ПередачаЗаполнитьНаСервере();
КонецПроцедуры

&НаСервере
Процедура ПередачаЗаполнитьНаСервере()
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Выборка.Месяц КАК Месяц,
	|	Выборка.ПередачаПоРаспоряжениям КАК ПередачаПоРаспоряжениям,
	|	Выборка.Организация КАК Организация,
	|	Выборка.Подразделение КАК Подразделение,
	|	Выборка.Склад КАК Склад,
	|	Выборка.КоличествоДокументов КАК КоличествоДокументов,
	|	Док.Ссылка КАК СводныйДокумент
	|ИЗ
	|	(ВЫБРАТЬ
	|		НАЧАЛОПЕРИОДА(Док.Дата, МЕСЯЦ) КАК Месяц,
	|		Док.ПередачаПоРаспоряжениям КАК ПередачаПоРаспоряжениям,
	|		Док.Организация КАК Организация,
	|		Док.Подразделение КАК Подразделение,
	|		Док.Склад КАК Склад,
	|		КОЛИЧЕСТВО(Док.Ссылка) КАК КоличествоДокументов
	|	ИЗ
	|		Документ.ПередачаМатериаловВПроизводство КАК Док
	|	ГДЕ
	|		Док.Дата МЕЖДУ &Дата1 И &Дата2
	|		И Док.Проведен
	|		И Док.ХозяйственнаяОперация = ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ПередачаВПроизводство)
	|		И Док.Организация = &Организация
	|	
	|	СГРУППИРОВАТЬ ПО
	|		НАЧАЛОПЕРИОДА(Док.Дата, МЕСЯЦ),
	|		Док.Организация,
	|		Док.Склад,
	|		Док.Подразделение,
	|		Док.ПередачаПоРаспоряжениям) КАК Выборка
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ПередачаМатериаловВПроизводство КАК Док
	|		ПО (Выборка.Месяц = НАЧАЛОПЕРИОДА(Док.Дата, МЕСЯЦ))
	|			И Выборка.ПередачаПоРаспоряжениям = Док.ПередачаПоРаспоряжениям
	|			И Выборка.Организация = Док.Организация
	|			И Выборка.Подразделение = Док.Подразделение
	|			И Выборка.Склад = Док.Склад
	|			И (Док.Комментарий ПОДОБНО ""Сводный документ%"")
	|
	|УПОРЯДОЧИТЬ ПО
	|	Подразделение,
	|	Склад
	|АВТОУПОРЯДОЧИВАНИЕ";
	
	Запрос.Параметры.Вставить("Дата1",       НачалоМесяца(Объект.Период));
	Запрос.Параметры.Вставить("Дата2",       КонецМесяца(Объект.Период));
	Запрос.Параметры.Вставить("Организация", Объект.Организация);
	
	Таблица = Запрос.Выполнить().Выгрузить();
	
	
	ТаблицаПередачаВПроизводство.Загрузить(Таблица);
	Для каждого СтрокаТЗ из ТаблицаПередачаВПроизводство Цикл
		
		Если СтрокаТЗ.КоличествоДокументов = 1 Тогда
			СтрокаТЗ.Результат = 2;
		Иначе
			СтрокаТЗ.Результат = 1;
			СтрокаТЗ.Пометка   = Истина;
		КонецЕсли;	
			
	КонецЦикла;	
	
КонецПроцедуры

&НаКлиенте
Процедура ПередачаСформироватьДокументы(Команда)
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ПередачаСформироватьДокументыОтвет", ЭтотОбъект);
	ПоказатьВопрос(ОписаниеОповещения, "Сформировать документы?", РежимДиалогаВопрос.ДаНет, 60);
	
КонецПроцедуры

&НаКлиенте
Процедура ПередачаСформироватьДокументыОтвет(Ответ, ДополнительныеПараметры) Экспорт
	
	Если Ответ <> КодВозвратаДиалога.Да Тогда
		Возврат;
	КонецЕсли;	
	
	Для каждого СтрокаТЗ из ТаблицаПередачаВПроизводство Цикл
		
		Если СтрокаТЗ.Пометка Тогда
			
			Состояние("" + СтрокаТЗ.Подразделение + " / " + СтрокаТЗ.Склад);
			
			ПараметрыДокумента = Новый Структура;
			ПараметрыДокумента.Вставить("Месяц",                   СтрокаТЗ.Месяц);
			ПараметрыДокумента.Вставить("ПередачаПоРаспоряжениям", СтрокаТЗ.ПередачаПоРаспоряжениям);
			ПараметрыДокумента.Вставить("Организация",             СтрокаТЗ.Организация);
			ПараметрыДокумента.Вставить("Подразделение",           СтрокаТЗ.Подразделение);
			ПараметрыДокумента.Вставить("Склад",                   СтрокаТЗ.Склад);
			ПараметрыДокумента.Вставить("КоличествоДокументов",    СтрокаТЗ.КоличествоДокументов);
			ПараметрыДокумента.Вставить("СворачиватьДокумент",     СворачиватьДокументыПередача);
			
			СтрокаТЗ.Результат = ПередачаСформироватьСводыйДокумент(ПараметрыДокумента, СтрокаТЗ.СводныйДокумент);
			Если СтрокаТЗ.Результат = 2 Тогда
				СтрокаТЗ.КоличествоДокументов = 1;
			КонецЕсли;	
			
			ОчиститьСообщения();
			ОбновитьОтображениеДанных(Элементы.ТаблицаПередачаВПроизводство);
			ОбработкаПрерыванияПользователя();
			
		КонецЕсли;
		
	КонецЦикла;	
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПередачаСформироватьСводыйДокумент(Знач ПараметрыДокумента, СводныйДокумент) Экспорт
	
	Если ПараметрыДокумента.КоличествоДокументов = 1 Тогда
		Возврат 2;
	КонецЕсли;	
	
	ВремяНачала = ТекущаяДата();
	
	Если ЗначениеЗаполнено(СводныйДокумент) Тогда
		ДокументОбъект = СводныйДокумент.ПолучитьОбъект();
	Иначе
		ДокументОбъект = Документы.ПередачаМатериаловВПроизводство.СоздатьДокумент();
		ДокументОбъект.Дата               = НачалоДня(КонецМесяца(ПараметрыДокумента.Месяц));
		ДокументОбъект.Организация        = ПараметрыДокумента.Организация;
		ДокументОбъект.Подразделение      = ПараметрыДокумента.Подразделение;
		ДокументОбъект.Склад              = ПараметрыДокумента.Склад;
		ДокументОбъект.Комментарий        = "Сводный документ";
	КонецЕсли;
	
	ДокументОбъект.ХозяйственнаяОперация      = Перечисления.ХозяйственныеОперации.ПередачаВПроизводство;
	ДокументОбъект.Статус                     = Перечисления.СтатусыПередачМатериаловВПроизводство.Принято;
	ДокументОбъект.ПередачаПоРаспоряжениям    = ПараметрыДокумента.ПередачаПоРаспоряжениям;
	ДокументОбъект.ПотреблениеДляДеятельности = Перечисления.ТипыНалогообложенияНДС.ПродажаОблагаетсяНДС;
	ДокументОбъект.Ответственный              = Пользователи.ТекущийПользователь();
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Док.Ссылка,
	|	Док.Номенклатура,
	|	Док.Характеристика,
	|	Док.Назначение,
	|	Док.НазначениеОтправителя,
	|	Док.Упаковка,
	|	Док.КоличествоУпаковок,
	|	Док.Количество,
	|	Док.КодСтроки,
	|	Док.СтатусУказанияСерий,
	|	ВЫБОР
	|		КОГДА Док.Ссылка.Распоряжение В (&ПустоеРаспоряжение)
	|			ТОГДА Док.Распоряжение
	|		ИНАЧЕ Док.Ссылка.Распоряжение
	|	КОНЕЦ КАК Распоряжение,
	|	Док.Серия,
	|	Док.СтатусУказанияСерийОтправитель,
	|	Док.СтатусУказанияСерийПолучатель,
	|	Док.ГруппаПродукции
	|ИЗ
	|	Документ.ПередачаМатериаловВПроизводство.Товары КАК Док
	|ГДЕ
	|	Док.Ссылка.Дата МЕЖДУ &Дата1 И &Дата2
	|	И Док.Ссылка.Проведен
	|	И Док.Ссылка.ПередачаПоРаспоряжениям = &ПередачаПоРаспоряжениям
	|	И Док.Ссылка.ХозяйственнаяОперация = ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ПередачаВПроизводство)
	|	И Док.Ссылка.Организация = &Организация
	|	И Док.Ссылка.Подразделение = &Подразделение
	|	И Док.Ссылка.Склад = &Склад";
	
	Запрос.Параметры.Вставить("Дата1",                   НачалоМесяца(ПараметрыДокумента.Месяц));
	Запрос.Параметры.Вставить("Дата2",                   КонецМесяца(ПараметрыДокумента.Месяц));
	Запрос.Параметры.Вставить("ПередачаПоРаспоряжениям", ПараметрыДокумента.ПередачаПоРаспоряжениям);
	Запрос.Параметры.Вставить("Организация",             ПараметрыДокумента.Организация);
	Запрос.Параметры.Вставить("Подразделение",           ПараметрыДокумента.Подразделение);
	Запрос.Параметры.Вставить("Склад",                   ПараметрыДокумента.Склад);
	Запрос.Параметры.Вставить("Комментарий",             "Сводный документ%");
	
	ПустоеПаспоряжение = Новый Массив;
	ПустоеПаспоряжение.Добавить(Неопределено);
	ПустоеПаспоряжение.Добавить(Документы.ЗаказНаПроизводство.ПустаяСсылка());
	ПустоеПаспоряжение.Добавить(Документы.ЗаказМатериаловВПроизводство.ПустаяСсылка());
	ПустоеПаспоряжение.Добавить(Документы.КорректировкаЗаказаМатериаловВПроизводство.ПустаяСсылка());
	ПустоеПаспоряжение.Добавить(Документы.ПередачаМатериаловВПроизводство.ПустаяСсылка());
	Запрос.Параметры.Вставить("ПустоеРаспоряжение", ПустоеПаспоряжение);
	
	ТаблицаДокумента = Запрос.Выполнить().Выгрузить();
	Если ТаблицаДокумента.Количество() = 0 Тогда
		// Документов нет, выходим
		Возврат 2;
	КонецЕсли;	
	
	ТаблицаСсылок = ТаблицаДокумента.Скопировать(, "Ссылка");
	ТаблицаСсылок.Свернуть("Ссылка");
	
	Если ПараметрыДокумента.СворачиватьДокумент Тогда
		
		ТаблицаДокумента.Свернуть("Номенклатура, Характеристика, Назначение, НазначениеОтправителя, Упаковка," +
			"КодСтроки, Распоряжение, СтатусУказанияСерий, Серия, СтатусУказанияСерийОтправитель, СтатусУказанияСерийПолучатель, ГруппаПродукции",
			"Количество, КоличествоУпаковок");
			
	КонецЕсли;	
	
	ДокументОбъект.Товары.Загрузить(ТаблицаДокумента);
	
	ДокументОбъект.Записать();
	СводныйДокумент = ДокументОбъект.Ссылка;
	
	Результат = ОтменитьДокументыИПровестиСводный(ДокументОбъект, ТаблицаСсылок);
	Возврат Результат;
	
КонецФункции	

#КонецОбласти

