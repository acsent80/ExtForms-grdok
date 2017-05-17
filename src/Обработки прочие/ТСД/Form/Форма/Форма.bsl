﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	//Элементы.Страницы.ОтображениеСтраниц = ОтображениеСтраницФормы.Нет;
	Элементы.СтраницыПриемка.ОтображениеСтраниц = ОтображениеСтраницФормы.Нет;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	// ПодключаемоеОборудование
	Если Источник = "ПодключаемоеОборудование" Тогда
		Если ИмяСобытия = "ScanData" И МенеджерОборудованияКлиентПереопределяемый.ЕстьНеобработанноеСобытие() Тогда
			ОбработатьШтрихкоды(МенеджерОборудованияКлиент.ПреобразоватьДанныеСоСканераВМассив(Параметр));
		КонецЕсли;
	КонецЕсли;
	// Конец ПодключаемоеОборудование
	
КонецПроцедуры

#КонецОбласти

&НаСервере
Процедура ПерейтиНаСтраницуГлавное()
	
	Элементы.Страницы.ТекущаяСтраница = Элементы.СтраницаГлавное;
	ВключитьСочетанияКлавишГлавное();
	
КонецПроцедуры	

&НаКлиенте
Процедура Приемка(Команда)
	
	ПриемкаСервер();
	
КонецПроцедуры

&НаСервере
Процедура ПриемкаСервер()
	
	ЗаполнитьСписокДокументов("ПриходныйОрдерНаТовары");
	ОтключитьСочетанияКлавишГлавное();
	
	Если ТаблицаДокументов.Количество() > 1 Тогда
		Элементы.СтраницыПриемка.ТекущаяСтраница = Элементы.СтраницаВыборПриходногоОрдера;
		ВключитьСочетанияКлавишВыборДокумента(ТаблицаДокументов.Количество());
	Иначе
		УстановитьТекущийОрдер(ТаблицаДокументов[0].ПолучитьИдентификатор());
	КонецЕсли;	
	
	Заголовок = "Приемка";
	Элементы.Страницы.ТекущаяСтраница = Элементы.СтраницаПриемка;
	
КонецПроцедуры


&НаСервере
Процедура ОтключитьСочетанияКлавишГлавное()
	
	Команды.Приемка.СочетаниеКлавиш    = Новый СочетаниеКлавиш(Клавиша.Нет);
	Команды.Отгрузка.СочетаниеКлавиш   = Новый СочетаниеКлавиш(Клавиша.Нет);
	Команды.Информация.СочетаниеКлавиш = Новый СочетаниеКлавиш(Клавиша.Нет);
	
КонецПроцедуры	

&НаСервере
Процедура ВключитьСочетанияКлавишГлавное()
	
	Команды.Приемка.СочетаниеКлавиш    = Новый СочетаниеКлавиш(Клавиша._1);
	Команды.Отгрузка.СочетаниеКлавиш   = Новый СочетаниеКлавиш(Клавиша._2);
	Команды.Информация.СочетаниеКлавиш = Новый СочетаниеКлавиш(Клавиша._3);
	
КонецПроцедуры	

&НаСервере
Процедура ОтключитьСочетанияКлавишВыборДокумента()
	
	Для Счетчик = 0 По 9 Цикл
		Команды["Документ" + Счетчик].СочетаниеКлавиш = Новый СочетаниеКлавиш(Клавиша.Нет);
	КонецЦикла;
	
КонецПроцедуры	

&НаСервере
Процедура ВключитьСочетанияКлавишВыборДокумента(Количество)
	
	Для Счетчик = 1 По Мин(9, Количество) Цикл
		Команды["Документ" + Счетчик].СочетаниеКлавиш = Новый СочетаниеКлавиш(Клавиша["_" + Счетчик]);
	КонецЦикла;
	
	Если Количество = 10 Тогда
		Команды["Документ10"].СочетаниеКлавиш = Новый СочетаниеКлавиш(Клавиша["_0"]);
	КонецЕсли;	
	
КонецПроцедуры	


&НаКлиенте
Процедура Отгрузка(Команда)
	
	Заголовок = "Отгрузка";
	Элементы.Страницы.ТекущаяСтраница = Элементы.СтраницаОтгрузка;
	
КонецПроцедуры

&НаКлиенте
Процедура Информация(Команда)
	
	Заголовок = "Информация";
	Элементы.Страницы.ТекущаяСтраница = Элементы.СтраницаИнформация;
	
КонецПроцедуры

&НаКлиенте
Процедура Назад(Команда)
	
	Заголовок = "Выберите операцию";
	Элементы.Страницы.ТекущаяСтраница = Элементы.СтраницаГлавное;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьПредставлениеДокумента(Номер, Дата, Номенклатура)
	
	Стр = Номер + " от " + Формат(Дата, "ДФ=dd.MM.yyyy");
	Если Найти(Номенклатура, "ФК") > 0 Тогда
		Стр = Стр + " (ФК)";
	ИначеЕсли Найти(Номенклатура, "Латофлекс") > 0 Тогда	
		Стр = Стр + " (ЛФ)";
	Иначе
		Стр = Стр + " (" + Номенклатура + ")";
	Конецесли;
	
	Возврат Стр;
	
КонецФункции	

&НаКлиенте
Процедура ОбработатьШтрихкоды(ДанныеШтрихкодов)
	
	Если ДанныеШтрихкодов.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;	
	
	Элементы.ТекстОшибки.Видимость = Ложь;
	
	флЕстьОшибка = Ложь;
	
	СтруктураОтбора = Новый Структура;
	СтруктураОтбора.Вставить("Штрихкод", ДанныеШтрихкодов[0].Штрихкод);
	
	НайденныеСтрокиПоСериям = ТаблицаВыполненияПоСериям.НайтиСтроки(СтруктураОтбора);
	Если НайденныеСтрокиПоСериям.Количество() > 0 Тогда
		
		СтрокаТЗ = НайденныеСтрокиПоСериям[0];
		Если СтрокаТЗ.Факт < СтрокаТЗ.План Тогда
			
			СтрокаТЗ.Факт = СтрокаТЗ.Факт + 1;
			ИтогоФакт = ИтогоФакт + 1;
			
			Если ИтогоПлан = ИтогоФакт Тогда
				Элементы.ЗавершитьПриемку.ЦветФона = WebЦвета.СветлоЗеленый;
			КонецЕсли;	
			
		Иначе
			Если ЗначениеЗаполнено(СтрокаТЗ.Серия) Тогда
				ТекстОшибки = Новый ФорматированнаяСтрока("Данная серия уже принята");
			Иначе	
				ТекстОшибки = Новый ФорматированнаяСтрока("Данный товар уже принят");
			КонецЕсли;	
			Элементы.ТекстОшибки.Видимость = Истина;
			флЕстьОшибка = Истина;
		КонецЕсли;	
		
		СтруктураОтбора = Новый Структура;
		СтруктураОтбора.Вставить("Номенклатура",   СтрокаТЗ.Номенклатура);
		СтруктураОтбора.Вставить("Характеристика", СтрокаТЗ.Характеристика);
		
		НайденныеСтроки = ТаблицаВыполнения.НайтиСтроки(СтруктураОтбора);
		СтрокаТЗ = НайденныеСтроки[0];
		Если флЕстьОшибка = Ложь Тогда
			СтрокаТЗ.Факт = СтрокаТЗ.Факт + 1;
		КонецЕсли;	
		
		Элементы.ТаблицаВыполнения.ТекущаяСтрока = СтрокаТЗ.ПолучитьИдентификатор();
		
	Иначе
	КонецЕсли;	
	
КонецПроцедуры	

&НаСервере
Функция ЗаполнитьТаблицуВыполнения(Тип)
	
	Запрос = Новый Запрос;
	Запрос.Параметры.Вставить("Ссылка", ТекущийДокумент);
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ДокТовары.Номенклатура,
	|	ДокТовары.Характеристика,
	|	ДокТовары.Серия,
	|	ДокТовары.Серия.Номер КАК СерияНомер,
	|	ДокТовары.Серия.ГоденДо КАК СерияГоденДо,
	|	ДокТовары.Количество,
	|	0 КАК План,
	|	ШтрихкодыНоменклатуры.Штрихкод
	|ИЗ
	|	Документ.ПриходныйОрдерНаТовары.Товары КАК ДокТовары
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ШтрихкодыНоменклатуры КАК ШтрихкодыНоменклатуры
	|		ПО ДокТовары.Номенклатура = ШтрихкодыНоменклатуры.Номенклатура
	|			И ДокТовары.Характеристика = ШтрихкодыНоменклатуры.Характеристика
	|ГДЕ
	|	ДокТовары.Ссылка = &Ссылка";
	
	Таблица = Запрос.Выполнить().Выгрузить();
	Для каждого СтрокаТЗ из Таблица Цикл
		
		Если ЗначениеЗаполнено(СтрокаТЗ.Серия) Тогда
			СтрокаТЗ.План     = 1;
			СтрокаТЗ.Штрихкод = _ПечатьЦенников.СформироватьШтрихкодСерии(СтрокаТЗ.СерияНомер, СтрокаТЗ.СерияГоденДо);
		Иначе
			
			СтрокаТЗ.План = _ОбщегоНазначенияДоп.ПолучитьКоличествоМест(СтрокаТЗ.Характеристика, СтрокаТЗ.Количество);
			Если СтрокаТЗ.План = 0 Тогда
				СтрокаТЗ.План = СтрокаТЗ.Количество;
			КонецЕсли;
			
		КонецЕсли;	
		
	КонецЦикла;	
	
	ТаблицаВыполненияПоСериям.Загрузить(Таблица);
	
	Таблица.Свернуть("Номенклатура, Характеристика", "План");
	ТаблицаВыполнения.Загрузить(Таблица);
	
	ИтогоПлан = ТаблицаВыполнения.Итог("План");
	ИтогоФакт = 0;
	
КонецФункции	
	
#Область Приемка

&НаСервере
Процедура ЗаполнитьСписокДокументов(Тип)
	
	Запрос = Новый Запрос;
	
	Если Тип = "ПриходныйОрдерНаТовары" Тогда
		
		Запрос.Параметры.Вставить("Статус", Перечисления.СтатусыПриходныхОрдеров.ТребуетсяОбработка);
		Запрос.Текст =
		"ВЫБРАТЬ ПЕРВЫЕ 10
		|	Док.Ссылка,
		|	Док.Номер,
		|	Док.Дата КАК Дата,
		|	ДокТовары.Номенклатура.Наименование КАК Номенклатура
		|ИЗ
		|	Документ.ПриходныйОрдерНаТовары КАК Док
		|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ПриходныйОрдерНаТовары.Товары КАК ДокТовары
		|		ПО (ДокТовары.Ссылка = Док.Ссылка)
		|			И (ДокТовары.НомерСтроки = 1)
		|ГДЕ
		|	Док.Проведен
		|	И Док.Статус = &Статус
		|
		|УПОРЯДОЧИТЬ ПО
		|	Дата";
	
	КонецЕсли;
	
	ТаблицаДокументов.Очистить();
	Номер = 0;
	
	Таблица = Запрос.Выполнить().Выгрузить();
	Для каждого СтрокаТЗ из Таблица Цикл
		
		Номер = Номер + 1;
		
		НоваяСтрока = ТаблицаДокументов.Добавить();
		НоваяСтрока.Номер  = Номер;
		НоваяСтрока.Ссылка = СтрокаТЗ.Ссылка;
		НоваяСтрока.Представление = ПолучитьПредставлениеДокумента(СтрокаТЗ.Номер, СтрокаТЗ.Дата, СтрокаТЗ.Номенклатура);
		
	КонецЦикла;	
	
КонецПроцедуры	

&НаСервере
Процедура УстановитьТекущийОрдер(ИДСтроки)
	
	СтрокаТЗ = ТаблицаДокументов.НайтиПоИдентификатору(ИДСтроки);
	
	Элементы.СтраницыПриемка.ТекущаяСтраница = Элементы.СтраницаВыполнениеПриемки;
	ТекущийДокумент      = СтрокаТЗ.Ссылка;
	ТекущийДокументТекст = СтрокаТЗ.Представление;
	
	ТекущийЭлемент = Элементы.ВвестиШтрихкод;
	
	ЗаполнитьТаблицуВыполнения("ПриходныйОрдерНаТовары");
	ОтключитьСочетанияКлавишВыборДокумента();
	
	Элементы.ЗавершитьПриемку.ЦветФона = Новый Цвет;
	
КонецПроцедуры	

&НаКлиенте
Процедура ТаблицаПриходныхОрдеровВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	УстановитьТекущийОрдер(ВыбраннаяСтрока);
	
КонецПроцедуры

&НаКлиенте
Процедура ВвестиШтрихкод(Команда)
	
	ОписаниеОповщения = Новый ОписаниеОповещения("ВвестиШтрихкодЗавершение", ЭтотОбъект);
	ПоказатьВводСтроки(ОписаниеОповщения, , "Введите штрихкод", 13, Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура ВвестиШтрихкодЗавершение(Значение, ДопПараметры) Экспорт
	
	Если Значение <> Неопределено Тогда
		ПослатьКодВСистему(Значение);
	КонецЕсли;	
	
КонецПроцедуры


&НаКлиенте
Процедура ПослатьКодВСистему(Шртихкод)
	
	глПодключаемоеОборудованиеСобытиеОбработано = Ложь;
	
	МассивПосыла = Новый Массив;
	МассивПосыла.Вставить(0, Шртихкод); //Это и есть штрихкод
	МассивПосыла.Вставить(1, Неопределено);
	Оповестить("ScanData", МассивПосыла, "ПодключаемоеОборудование");
	
КонецПроцедуры

&НаКлиенте
Процедура ЗавершитьПриемку(Команда)
	
	Если ИтогоФакт = 0 Тогда
		
		ОтключитьСочетанияКлавишВыборДокумента();
		ВключитьСочетанияКлавишГлавное();
		Элементы.Страницы.ТекущаяСтраница = Элементы.СтраницаГлавное;
		
	ИначеЕсли ИтогоФакт < ИтогоПлан Тогда
		
		Кнопки = Новый СписокЗначений;
		Кнопки.Добавить("Продолжить");
		Кнопки.Добавить("Принять введенное");
		Кнопки.Добавить("Отменить");
		
		ОписаниеОповещения = Новый ОписаниеОповещения("ЗавершитьПриемкуВопрос", ЭтотОбъект);
		
		ПоказатьВопрос(ОписаниеОповещения, "Приемка не завершена", Кнопки, 100);
		
	Иначе
		
		ЗавершитьПриемкуПоДокументу();
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗавершитьПриемкуВопрос(Ответ, ДопПараметры) Экспорт
	
	Если Ответ = "Принять введенное" Тогда
		
		ЗавершитьПриемкуПоДокументуЧастично();
		
	ИначеЕсли Ответ = "Отменить" Тогда
		
		ПерейтиНаСтраницуГлавное();
		
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаДокумент(Команда)
	
	Индекс = Число(Прав(Команда.Имя, 1)); 
	Если Индекс = 0 Тогда
		Индекс = 10;
	КонецЕсли;
	
	ИДСтроки = ТаблицаДокументов[Индекс-1].ПолучитьИдентификатор();
	
	УстановитьТекущийОрдер(ИДСтроки);
	
КонецПроцедуры

&НаСервере
Процедура ЗавершитьПриемкуПоДокументу()
	
	ДокументОбъект = ТекущийДокумент.ПолучитьОбъект();
	ДокументОбъект.Статус = Перечисления.СтатусыПриходныхОрдеров.Принят;
	
	Попытка
		ДокументОбъект.Записать(РежимЗаписиДокумента.Проведение);
		ПерейтиНаСтраницуГлавное();
	Исключение	
		ТекстОшибки = "Не удалось записать документ";
		Элементы.ТекстОшибки.Видимость = Истина;
		Элементы.ТекстОшибки.Подсказка = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
	КонецПопытки;	
	
КонецПроцедуры

&НаСервере
Процедура ЗавершитьПриемкуПоДокументуЧастично()
	
	ДокументОбъект = ТекущийДокумент.ПолучитьОбъект();
	ДокументОбъект.Статус = Перечисления.СтатусыПриходныхОрдеров.Принят;
	
	СтруктураОтбора = Новый Структура;
	СтруктураОтбора.Вставить("Номенклатура");
	СтруктураОтбора.Вставить("Характеристика");
	СтруктураОтбора.Вставить("Серия");
	
	Для каждого СтрокаТЗ из ТаблицаВыполненияПоСериям Цикл
		
		Если СтрокаТЗ.Факт = СтрокаТЗ.План Тогда
			Продолжить;
		КонецЕсли;	
		
		ЗаполнитьЗначенияСвойств(СтруктураОтбора, СтрокаТЗ);
		НайденныеСтроки = ДокументОбъект.Товары.НайтиСтроки(СтруктураОтбора);
		Если НайденныеСтроки.Количество() = 0 Тогда
			Продолжить;
		КонецЕсли;	
		
		СтрокаТЧ = НайденныеСтроки[0];
		
		Если СтрокаТЗ.Факт = 0 Тогда
			ДокументОбъект.Товары.Удалить(СтрокаТЧ);
		Иначе	
			СтрокаТЧ.Количество = СтрокаТЧ.Количество * СтрокаТЗ.Факт / СтрокаТЗ.План;
			СтрокаТЧ.КоличествоУпаковок = СтрокаТЧ.КоличествоУпаковок * СтрокаТЗ.Факт / СтрокаТЗ.План;
		КонецЕсли;	
		
	КонецЦикла;	
	
	Попытка
		ДокументОбъект.Записать(РежимЗаписиДокумента.Проведение);
		ПерейтиНаСтраницуГлавное();
	Исключение	
		ТекстОшибки = "Не удалось записать документ";
		Элементы.ТекстОшибки.Видимость = Истина;
		Элементы.ТекстОшибки.Подсказка = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
	КонецПопытки;	
	
КонецПроцедуры

#КонецОбласти

