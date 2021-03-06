﻿
//+yuraos, 10.09.2015
&НаСервере
Перем СтрокаОбщиеОбъекты;
&НаСервере
Перем ТекушаяСтрока;
//+yuraos, 10.09.2015

////////////////////////////////////////////////////////////////////////////////
//                          ИСПОЛЬЗОВАНИЕ ФОРМЫ                               //
//
// Форма предназначена для выбора объектов метаданных конфигурации и передачи
// выбранных их списка в вызывающую среду.
//
// Параметры вызова:
// КоллекцииВыбираемыхОбъектовМетаданных - СписокЗначений - фактически фильтр
//				по типам объектов метаданных, которые могут быть выбраны.
//				Например:
//					ФильтрПоСсылочнымМетаданным = Новый СписокЗначений;
//					ФильтрПоСсылочнымМетаданным.Добавить("Справочники");
//					ФильтрПоСсылочнымМетаданным.Добавить("Документы");
//				Позволяет выбирать только объекты метаданных справочники и документы
//

///////////////////////////////////////////////////////////////////////////////
//                      БЛОК ОБРАБОТЧИКОВ СОБЫТИЙ                            //
///////////////////////////////////////////////////////////////////////////////

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	//+yuraos, 10.09.2015
	ТекушаяСтрока = Неопределено;
	yuraosИнициализация();
	//+yuraos, 10.09.2015
	
	ДеревоОбъектовМетаданныхЗаполнить();
	
	//+yuraos, 10.09.2015
	Если ТекушаяСтрока <> Неопределено Тогда
		Элементы.ДеревоОбъектовМетаданных.ТекущаяСтрока = ТекушаяСтрока;
	КонецЕсли; 
	ЭтаФорма.УзелОбщиеОбъекты = СтрокаОбщиеОбъекты;
	//ЭтаФорма.ПоказыватьИменаОбъектов = ХранилищеНастроекДанныхФорм.Загрузить(ИмяФормы, "ПоказыватьИменаОбъектов");
	ЭтаФорма.ПоказыватьИменаОбъектов = Истина;
	ФормаКонтрольПоказыватьИменаОбъектовСервер();
	//+yuraos, 10.09.2015
			
КонецПроцедуры

///////////////////////////////////////////////////////////////////////////////
//                      БЛОК ВСПОМОГАТЕЛЬНЫЙ ФУНКЦИЙ                         //
///////////////////////////////////////////////////////////////////////////////

// Процедура заполняет дерево значений объектов конфигурации.
// Если список значений "Параметры.КоллекцииВыбираемыхОбъектовМетаданных" не пуст, тогда
// дерево будет ограничено переданным списком коллекций объектов метаданных.
//  Если объекты метаданных в сформированном дереве будут найдены в списке значений
// "Параметры.ВыбранныеОбъектыМетаданных", тогда они будут помечены, как выбранные.
//
&НаСервере
Процедура ДеревоОбъектовМетаданныхЗаполнить()
	
	КоллекцииОбъектовМетаданных = Новый ТаблицаЗначений;
	КоллекцииОбъектовМетаданных.Колонки.Добавить("Имя");
	КоллекцииОбъектовМетаданных.Колонки.Добавить("Синоним");
	КоллекцииОбъектовМетаданных.Колонки.Добавить("Картинка");
	КоллекцииОбъектовМетаданных.Колонки.Добавить("КартинкаОбъекта");
	КоллекцииОбъектовМетаданных.Колонки.Добавить("ЭтоКоллекцияОбщие");
	
	КоллекцииОбъектовМетаданных_НоваяСтрока("Подсистемы",                   "Подсистемы",                     35, 36, Истина, КоллекцииОбъектовМетаданных);
	КоллекцииОбъектовМетаданных_НоваяСтрока("ОбщиеМодули",                  "Общие модули",                   37, 38, Истина, КоллекцииОбъектовМетаданных);
	КоллекцииОбъектовМетаданных_НоваяСтрока("ПараметрыСеанса",              "Параметры сеанса",               39, 40, Истина, КоллекцииОбъектовМетаданных);
	КоллекцииОбъектовМетаданных_НоваяСтрока("Роли",                         "Роли",                           41, 42, Истина, КоллекцииОбъектовМетаданных);
	
	КоллекцииОбъектовМетаданных_НоваяСтрока("ПланыОбмена",                  "Планы обмена",                   БиблиотекаКартинок.ПланОбмена, БиблиотекаКартинок.ПланОбменаОбъект, Истина, КоллекцииОбъектовМетаданных);
	//КоллекцииОбъектовМетаданных_НоваяСтрока("ПланыОбмена",                "Планы обмена",                   43, 44, Истина, КоллекцииОбъектовМетаданных); //*yuraos, 10.09.2015
	
	КоллекцииОбъектовМетаданных_НоваяСтрока("КритерииОтбора",               "Критерии отбора",                45, 46, Истина, КоллекцииОбъектовМетаданных);
	КоллекцииОбъектовМетаданных_НоваяСтрока("ПодпискиНаСобытия",            "Подписки на события",            47, 48, Истина, КоллекцииОбъектовМетаданных);
	КоллекцииОбъектовМетаданных_НоваяСтрока("РегламентныеЗадания",          "Регламентные задания",           49, 50, Истина, КоллекцииОбъектовМетаданных);
	КоллекцииОбъектовМетаданных_НоваяСтрока("ФункциональныеОпции",          "Функциональные опции",           51, 52, Истина, КоллекцииОбъектовМетаданных);
	КоллекцииОбъектовМетаданных_НоваяСтрока("ПараметрыФункциональныхОпций", "Параметры функциональных опций", 53, 54, Истина, КоллекцииОбъектовМетаданных);
	КоллекцииОбъектовМетаданных_НоваяСтрока("ХранилищаНастроек",            "Хранилища настроек",             55, 56, Истина, КоллекцииОбъектовМетаданных);
	КоллекцииОбъектовМетаданных_НоваяСтрока("ОбщиеФормы",                   "Общие формы",                    57, 58, Истина, КоллекцииОбъектовМетаданных);
	КоллекцииОбъектовМетаданных_НоваяСтрока("ОбщиеКоманды",                 "Общие команды",                  59, 60, Истина, КоллекцииОбъектовМетаданных);
	КоллекцииОбъектовМетаданных_НоваяСтрока("ГруппыКоманд",                 "Группы команд",                  61, 62, Истина, КоллекцииОбъектовМетаданных);
	КоллекцииОбъектовМетаданных_НоваяСтрока("Интерфейсы",                   "Интерфейсы",                     63, 64, Истина, КоллекцииОбъектовМетаданных);
	КоллекцииОбъектовМетаданных_НоваяСтрока("ОбщиеМакеты",                  "Общие макеты",                   65, 66, Истина, КоллекцииОбъектовМетаданных);
	КоллекцииОбъектовМетаданных_НоваяСтрока("ОбщиеКартинки",                "Общие картинки",                 67, 68, Истина, КоллекцииОбъектовМетаданных);
	КоллекцииОбъектовМетаданных_НоваяСтрока("ПакетыXDTO",                   "XDTO-пакеты",                    69, 70, Истина, КоллекцииОбъектовМетаданных);
	КоллекцииОбъектовМетаданных_НоваяСтрока("WebСервисы",                   "Web-сервисы",                    71, 72, Истина, КоллекцииОбъектовМетаданных);
	КоллекцииОбъектовМетаданных_НоваяСтрока("WSСсылки",                     "WS-ссылки",                      73, 74, Истина, КоллекцииОбъектовМетаданных);
	КоллекцииОбъектовМетаданных_НоваяСтрока("Стили",                        "Стили",                          75, 76, Истина, КоллекцииОбъектовМетаданных);
	КоллекцииОбъектовМетаданных_НоваяСтрока("Языки",                        "Языки",                          77, 78, Истина, КоллекцииОбъектовМетаданных);
	
	КоллекцииОбъектовМетаданных_НоваяСтрока("Константы",                    "Константы",                      БиблиотекаКартинок.Константа,              БиблиотекаКартинок.Константа,                    Ложь, КоллекцииОбъектовМетаданных);
	
	КоллекцииОбъектовМетаданных_НоваяСтрока("Справочники",                  "Справочники",                    БиблиотекаКартинок.Справочник,             БиблиотекаКартинок.СправочникОбъект,             Ложь, КоллекцииОбъектовМетаданных);
	//КоллекцииОбъектовМетаданных_НоваяСтрока("Справочники",                "Справочники",                    БиблиотекаКартинок.Справочник,             БиблиотекаКартинок.Справочник,                   Ложь, КоллекцииОбъектовМетаданных); //*yuraos, 10.09.2015
	
	КоллекцииОбъектовМетаданных_НоваяСтрока("Документы",                    "Документы",                      БиблиотекаКартинок.Документ,               БиблиотекаКартинок.ДокументОбъект,               Ложь, КоллекцииОбъектовМетаданных);
	КоллекцииОбъектовМетаданных_НоваяСтрока("ЖурналыДокументов",            "Журналы документов",             БиблиотекаКартинок.ЖурналДокументов,       БиблиотекаКартинок.ЖурналДокументов,             Ложь, КоллекцииОбъектовМетаданных);
	КоллекцииОбъектовМетаданных_НоваяСтрока("Перечисления",                 "Перечисления",                   БиблиотекаКартинок.Перечисление,           БиблиотекаКартинок.Перечисление,                 Ложь, КоллекцииОбъектовМетаданных);
	КоллекцииОбъектовМетаданных_НоваяСтрока("Отчеты",                       "Отчеты",                         БиблиотекаКартинок.Отчет,                  БиблиотекаКартинок.Отчет,                        Ложь, КоллекцииОбъектовМетаданных);
	КоллекцииОбъектовМетаданных_НоваяСтрока("Обработки",                    "Обработки",                      БиблиотекаКартинок.Обработка,              БиблиотекаКартинок.Обработка,                    Ложь, КоллекцииОбъектовМетаданных);
	КоллекцииОбъектовМетаданных_НоваяСтрока("ПланыВидовХарактеристик",      "Планы видов характеристик",      БиблиотекаКартинок.ПланВидовХарактеристик, БиблиотекаКартинок.ПланВидовХарактеристикОбъект, Ложь, КоллекцииОбъектовМетаданных);
	КоллекцииОбъектовМетаданных_НоваяСтрока("ПланыСчетов",                  "Планы счетов",                   БиблиотекаКартинок.ПланСчетов,             БиблиотекаКартинок.ПланСчетовОбъект,             Ложь, КоллекцииОбъектовМетаданных);
	КоллекцииОбъектовМетаданных_НоваяСтрока("ПланыВидовРасчета",            "Планы видов расчета",     		  БиблиотекаКартинок.ПланВидовРасчета,       БиблиотекаКартинок.ПланВидовРасчетаОбъект,       Ложь, КоллекцииОбъектовМетаданных);
	
	КоллекцииОбъектовМетаданных_НоваяСтрока("РегистрыСведений",             "Регистры сведений",              БиблиотекаКартинок.РегистрСведений,        БиблиотекаКартинок.РегистрСведенийЗапись,        Ложь, КоллекцииОбъектовМетаданных);
	//КоллекцииОбъектовМетаданных_НоваяСтрока("РегистрыСведений",           "Регистры сведений",              БиблиотекаКартинок.РегистрСведений,        БиблиотекаКартинок.РегистрСведений,              Ложь, КоллекцииОбъектовМетаданных); //*yuraos, 10.09.2015
	
	КоллекцииОбъектовМетаданных_НоваяСтрока("РегистрыНакопления",           "Регистры накопления",            БиблиотекаКартинок.РегистрНакопления,      БиблиотекаКартинок.РегистрНакопления,            Ложь, КоллекцииОбъектовМетаданных);
	КоллекцииОбъектовМетаданных_НоваяСтрока("РегистрыБухгалтерии",          "Регистры бухгалтерии",           БиблиотекаКартинок.РегистрБухгалтерии,     БиблиотекаКартинок.РегистрБухгалтерии,           Ложь, КоллекцииОбъектовМетаданных);
	КоллекцииОбъектовМетаданных_НоваяСтрока("РегистрыРасчета",              "Регистры расчета",               БиблиотекаКартинок.РегистрРасчета,         БиблиотекаКартинок.РегистрРасчета,               Ложь, КоллекцииОбъектовМетаданных);
	КоллекцииОбъектовМетаданных_НоваяСтрока("БизнесПроцессы",               "Бизнес-процессы",                БиблиотекаКартинок.БизнесПроцесс,          БиблиотекаКартинок.БизнесПроцессОбъект,          Ложь, КоллекцииОбъектовМетаданных);
	КоллекцииОбъектовМетаданных_НоваяСтрока("Задачи",                       "Задачи",                         БиблиотекаКартинок.Задача,                 БиблиотекаКартинок.ЗадачаОбъект,                 Ложь, КоллекцииОбъектовМетаданных);
	
	//+yuraos, 10.09.2015
	Попытка
	Коллекция = Метаданные.ВнешниеИсточникиДанных; // появилась начиная с 8.3.14	
	КоллекцииОбъектовМетаданных_НоваяСтрока("ВнешниеИсточникиДанных",       "Внешние источники данных",       БиблиотекаКартинок.ВнешнийИсточникДанных,  БиблиотекаКартинок.ВнешнийИсточникДанныхКуб,     Ложь, КоллекцииОбъектовМетаданных);
	Исключение
	КонецПопытки;
	//+yuraos, 10.09.2015
	
	// Создание предопределенных элементов.
	ЭлементКонфигурация = НоваяСтрокаДерева(Метаданные.Имя, "", Метаданные.Синоним, 79, ДеревоОбъектовМетаданных);
	ЭлементОбщие        = НоваяСтрокаДерева("Общие",        "", "Общие",             0, ЭлементКонфигурация);
	
	// Заполнение дерева объектов метаданных.
	Для каждого Строка ИЗ КоллекцииОбъектовМетаданных Цикл
		Если Параметры.КоллекцииВыбираемыхОбъектовМетаданных.Количество() = 0 ИЛИ
			 Параметры.КоллекцииВыбираемыхОбъектовМетаданных.НайтиПоЗначению(Строка.Имя) <> Неопределено Тогда
			ВыводКоллекцииОбъектовМетаданных(Строка.Имя,
											"",
											Строка.Синоним,
											Строка.Картинка,
											Строка.КартинкаОбъекта,
											?(Строка.ЭтоКоллекцияОбщие, ЭлементОбщие, ЭлементКонфигурация),
											?(Строка.Имя = "Подсистемы", Метаданные.Подсистемы, Неопределено));
		КонецЕсли;
	КонецЦикла;
	
	//+yuraos, 10.09.2015
	Если ЭлементОбщие.ПолучитьЭлементы().Количество() = 0 Тогда
		СтрокаОбщиеОбъекты = 0;
		ЭлементКонфигурация.ПолучитьЭлементы().Удалить(ЭлементОбщие);
	Иначе
		СтрокаОбщиеОбъекты = ЭлементОбщие.ПолучитьИдентификатор();
	КонецЕсли;
	//+yuraos, 10.09.2015
	
	////-yuraos, 10.09.2015
	//Если ЭлементОбщие.ПолучитьЭлементы().Количество() = 0 Тогда
	//	ЭлементКонфигурация.ПолучитьЭлементы().Удалить(ЭлементОбщие);
	//КонецЕсли;
	////-yuraos, 10.09.2015
	
КонецПроцедуры

// Функция, добавляющая одну строку в дерево значений формы - дерево,
// а так же заполняющая полный набор строк из метаданных по переданному параметру
// Если параметр Подсистемы заполнен, то вызывается рекурсивно из за того,
// что подсистемы могут содержать подсистемы
// Парметры:
// Имя           - имя родительского элемента
// Синоним       - синоним родительского элемента
// Пометка       - Булево, начальная пометка коллекции или объекта метаданных.
// Картинка      - код картинки родительского элемента
// КартинкаОбъекта - код картинки подэлемента
// Родитель      - ссылка на элемента дерева значений который является корнем
//                 для добавляемого элемента
// Подсистемы    - если заполнен то содержит значение Метаданные.Подсистемы
//                 т.е. коллекцию элементов
// Проверять     - булево, признак проверки на принадлежность родительским подсистемам
// 
// Возвращаемое значение:
// 
//
&НаСервере
Функция ВыводКоллекцииОбъектовМетаданных(Имя, ПолноеИмя, Синоним, Картинка, КартинкаОбъекта, Родитель = Неопределено, Подсистемы = Неопределено, Проверять = Истина)
	
	НоваяСтрока = НоваяСтрокаДерева(Имя, ПолноеИмя, Синоним, Картинка, Родитель, Подсистемы <> Неопределено И Подсистемы <> Метаданные.Подсистемы);
	
	Для каждого ЭлементКоллекцииМетаданных ИЗ Метаданные[Имя] Цикл
		НоваяСтрокаДерева(ЭлементКоллекцииМетаданных.Имя,
						ЭлементКоллекцииМетаданных.ПолноеИмя(),
						ЭлементКоллекцииМетаданных.Синоним,
						КартинкаОбъекта,
						НоваяСтрока,
						Истина);
	КонецЦикла;
	
	Возврат НоваяСтрока;
	
КонецФункции

// Добавляет новую строку в дерево формы
// Имя           - имя элемента
// Синоним       - синоним элемента
// Картинка      - код картинки
// Родитель      - элемент дерева значений формы, от которого отращивается новая ветка
//
// Возвращаемое значение:
//  ДанныеФормыЭлементДерево - отрощенная ветвь дерева
//
&НаСервере
Функция НоваяСтрокаДерева(Имя, ПолноеИмя, Синоним, Картинка, Родитель, ЭтоОбъектМетаданных = Ложь)
	
	Коллекция = Родитель.ПолучитьЭлементы();
	НоваяСтрока = Коллекция.Добавить();
	НоваяСтрока.Имя                 = Имя;
	НоваяСтрока.Представление       = ?(ЗначениеЗаполнено(Синоним), Синоним, Имя);
	НоваяСтрока.Картинка            = Картинка;
	НоваяСтрока.ПолноеИмя           = ПолноеИмя;
	НоваяСтрока.ЭтоОбъектМетаданных = ЭтоОбъектМетаданных;
	
	//+yuraos, 10.09.2015
	Если ЭтоОбъектМетаданных = Истина И Параметры.Свойство("ТипОбъектаСтрокой") И ЗначениеЗаполнено(Параметры.ТипОбъектаСтрокой) Тогда
		Если СтрЗаменить(Параметры.ТипОбъектаСтрокой, "Ссылка.", ".") = НоваяСтрока.ПолноеИмя Тогда
			ТекушаяСтрока = НоваяСтрока.ПолучитьИдентификатор();
		КонецЕсли; 
	КонецЕсли; 
	//+yuraos, 10.09.2015
	
	Возврат НоваяСтрока;
	
КонецФункции

// Добавляет новую строку в таблицу значений видов объектов метаданных
// конфигурации
//
// Параметры:
// Имя           - имя объекта метаданных или вида объекта метаданных
// Синоним       - синоним объекта метаданных
// Картинка      - картинка поставленная в соответствие объекту метаданных
//                 или виду объекта метаданных
// ЭтоКоллекцияОбщие - признак того, что текущий элемент содержит подэлементы
//
&НаСервере
Процедура КоллекцииОбъектовМетаданных_НоваяСтрока(Имя, Синоним, Картинка, КартинкаОбъекта, ЭтоКоллекцияОбщие, Таб)
	
	НоваяСтрока = Таб.Добавить();
	НоваяСтрока.Имя               = Имя;
	НоваяСтрока.Синоним           = Синоним;
	НоваяСтрока.Картинка          = Картинка;
	НоваяСтрока.КартинкаОбъекта   = КартинкаОбъекта;
	НоваяСтрока.ЭтоКоллекцияОбщие = ЭтоКоллекцияОбщие;
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоОбъектовМетаданныхВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	//+yuraos, 10.09.2015
	Если Элемент.ТекущиеДанные.ЭтоОбъектМетаданных = Ложь Тогда
		Возврат;
	КонецЕсли; 
	//+yuraos, 10.09.2015
	
	//*yuraos, 10.09.2015
	Если ЭтаФорма.МодальныйРежим Тогда
		ЭтаФорма.Закрыть(Элемент.ТекущиеДанные.ПолноеИмя);
	Иначе
		ОповеститьОВыборе(Элемент.ТекущиеДанные.ПолноеИмя);
	КонецЕсли; 
	//*yuraos, 10.09.2015
	
КонецПроцедуры


//+yuraos, 10.09.2015
&НаКлиенте
Процедура ПриОткрытии(Отказ)
	Если ЭтаФорма.УзелОбщиеОбъекты > 0 И НЕ Элементы.ДеревоОбъектовМетаданных.Развернут(ЭтаФорма.УзелОбщиеОбъекты) Тогда
		Элементы.ДеревоОбъектовМетаданных.Развернуть(ЭтаФорма.УзелОбщиеОбъекты, Ложь);
	КонецЕсли; 
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ФормаСохранитьНастройки(ИмяФормы,ЗначенияНастроек)
	Для каждого КЗ Из ЗначенияНастроек Цикл
		ХранилищеНастроекДанныхФорм.Сохранить(ИмяФормы,КЗ.Ключ,КЗ.Значение);
	КонецЦикла; 
КонецПроцедуры

&НаСервере
Процедура ФормаКонтрольПоказыватьИменаОбъектовСервер()
	Элементы.Имя.Видимость = ЭтаФорма.ПоказыватьИменаОбъектов;
	Элементы.Представление.Видимость = НЕ ЭтаФорма.ПоказыватьИменаОбъектов;
	Элементы.ПоказыватьИменаОбъектов.Пометка = ЭтаФорма.ПоказыватьИменаОбъектов;
КонецПроцедуры

&НаКлиенте
Процедура ФормаКонтрольПоказыватьИменаОбъектовКлиент()
	Элементы.Имя.Видимость = ЭтаФорма.ПоказыватьИменаОбъектов;
	Элементы.Представление.Видимость = НЕ ЭтаФорма.ПоказыватьИменаОбъектов;
	Элементы.ПоказыватьИменаОбъектов.Пометка = ЭтаФорма.ПоказыватьИменаОбъектов;
КонецПроцедуры

&НаКлиенте
Процедура ПоказыватьИменаОбъектов(Команда)
	ЭтаФорма.ПоказыватьИменаОбъектов = Не ЭтаФорма.ПоказыватьИменаОбъектов;
	ФормаСохранитьНастройки(ЭтаФорма.ИмяФормы,Новый Структура("ПоказыватьИменаОбъектов",ЭтаФорма.ПоказыватьИменаОбъектов));
	ФормаКонтрольПоказыватьИменаОбъектовКлиент();
КонецПроцедуры

&НаКлиенте
Процедура СвернутьВсеУзлыТипов(Команда)
	Элемент = Элементы.ДеревоОбъектовМетаданных;
	Для каждого Строка0 Из ДеревоОбъектовМетаданных.ПолучитьЭлементы() Цикл
		Ид0 = Строка0.ПолучитьИдентификатор();
		Если Элемент.Развернут(Ид0) = Ложь Тогда
			Элемент.Развернуть(Ид0);
		КонецЕсли; 
		Для каждого Строка1 Из Строка0.ПолучитьЭлементы() Цикл
			Ид1 = Строка1.ПолучитьИдентификатор();
			Если Строка1.Имя = "Общие" Тогда
				Если Элемент.Развернут(Ид1) = Ложь Тогда
					Элемент.Развернуть(Ид1);
				КонецЕсли;
				Для каждого Строка2 Из Строка1.ПолучитьЭлементы() Цикл
					Ид2 = Строка2.ПолучитьИдентификатор();
					Если Элемент.Развернут(Ид2) = Истина Тогда
						Элемент.Свернуть(Ид2);
					КонецЕсли; 
				КонецЦикла; 
			Иначе
				Если Элемент.Развернут(Ид1) = Истина Тогда
					Элемент.Свернуть(Ид1);
				КонецЕсли; 
			КонецЕсли; 
		КонецЦикла; 
	КонецЦикла; 
КонецПроцедуры

&НаСервере
Процедура yuraosИнициализация()
	ЭтаФорма.УстановитьДействие("ПриОткрытии", "ПриОткрытии");
	мсДобавить = Новый Массив;
	мсДобавить.Добавить(Новый РеквизитФормы("ПоказыватьИменаОбъектов", Новый ОписаниеТипов("Булево") , , , Ложь));
	мсДобавить.Добавить(Новый РеквизитФормы("УзелОбщиеОбъекты", Новый ОписаниеТипов("Число",
															    Новый КвалификаторыЧисла(10, 0, ДопустимыйЗнак.Любой)), , , Ложь));
	ЭтаФорма.ИзменитьРеквизиты(мсДобавить);
	
	// команда "Свернуть все узлы" контекстного меню списка объектов метаданных
	Команда = ЭтаФорма.Команды.Добавить("СвернутьВсеУзлыТипов");
	Команда.Заголовок = "Свернуть все узлы типов";
	Команда.Подсказка = "Свернуть все узлы типов объектов в списке";
	Команда.Действие = "СвернутьВсеУзлыТипов";
	Команда.Отображение = ОтображениеКнопки.КартинкаИТекст;
	Команда.Картинка = БиблиотекаКартинок.ТабличныйДокументОтображатьГруппировки;
		
	Кнопка = Элементы.Добавить(Команда.Имя, Тип("КнопкаФормы"), Элементы.ДеревоОбъектовМетаданных.КонтекстноеМеню);
	Кнопка.ИмяКоманды = Команда.Имя;
	Кнопка.ТолькоВоВсехДействиях = Ложь;
	
	// команда "Показывать имена" контекстного меню списка объектов метаданных
	Команда = ЭтаФорма.Команды.Добавить("ПоказыватьИменаОбъектов");
	Команда.Заголовок = "Показывать имена объектов";
	Команда.Подсказка = "Показывать имена объектов (иначе - показывать синонимы)";
	Команда.Действие = "ПоказыватьИменаОбъектов";
	Команда.Отображение = ОтображениеКнопки.Текст;
		
	Кнопка = Элементы.Добавить(Команда.Имя, Тип("КнопкаФормы"), Элементы.ДеревоОбъектовМетаданных.КонтекстноеМеню);
	Кнопка.ИмяКоманды = Команда.Имя;
	Кнопка.ТолькоВоВсехДействиях = Ложь;
	
	Поле = Элементы.Добавить("Имя", Тип("ПолеФормы"),Элементы.Группа);
	Поле.Вид = ВидПоляФормы.ПолеВвода;
	Поле.ПутьКДанным = "ДеревоОбъектовМетаданных.Имя";
	ЗаполнитьЗначенияСвойств(Поле,Элементы.Представление,,"Имя,Вид,ПутьКДанным,ТекстРедактирования,ВыделенныйТекст,СвязьПоТипу");	// МА!
КонецПроцедуры

//+yuraos, 10.09.2015



