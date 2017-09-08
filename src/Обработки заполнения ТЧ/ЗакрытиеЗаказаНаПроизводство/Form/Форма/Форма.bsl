﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если ТипЗнч(Параметры.ОбъектыНазначения) = Тип("Массив") Тогда
		
		Для каждого ДокументСсылка из Параметры.ОбъектыНазначения Цикл
			
			Объект.ЗаказНаПроизводство = ДокументСсылка;
			ЗаполнитьНаСервере();
			Элементы.ЗаказНаПроизводство.ТолькоПросмотр = Истина;
			Элементы.ФормаЗаполнить.Видимость = Ложь;
			Прервать;
			
		КонецЦикла;	
		
	КонецЕсли;
	
	Объект.ВариантСократитьПроизводство = "ОтменитьВыполнение";
	
КонецПроцедуры

&НаКлиенте
Процедура Заполнить(Команда)
	ЗаполнитьНаСервере();
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьНаСервере()
	
	ОбработкаОбъект = РеквизитФормыВЗначение("Объект");
	ОбработкаОбъект.Заполнить();
	
	ЗначениеВРеквизитФормы(ОбработкаОбъект, "Объект");
	
	Если Объект.Выпуск.Количество() = 0 Тогда
		Элементы.ГруппаВыпуск.Видимость = Ложь;
	Иначе	
		Элементы.ГруппаВыпуск.Видимость = Истина;
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура ЗакрытьЗаказ(Команда)
	
	Если Объект.Выпуск.Количество() > 0 Тогда
		ПоказатьПредупреждение(, "Не полностью оформлен выпуск", 60);
		Возврат;
	КонецЕсли;	
	
	Результат = ЗакрытьЗаказНаСервере();
	Если Результат = "Уже закрыт" Тогда
		ПоказатьПредупреждение(, "Заказ уже закрыт", 60);
		Возврат;
	КонецЕсли;	
	
	Для каждого ДокументСсылка из Результат Цикл
		ПоказатьОповещениеПользователя("Создан документ", ПолучитьНавигационнуюСсылку(ДокументСсылка), Строка(ДокументСсылка));
	КонецЦикла;	
	
КонецПроцедуры

&НаСервере
Функция ЗакрытьЗаказНаСервере()
	
	ОбработкаОбъект = РеквизитФормыВЗначение("Объект");
	Результат = ОбработкаОбъект.ЗакрытьЗаказ();
	
	Возврат Результат;
	
КонецФункции

&НаКлиенте
Процедура ВыпускВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ТекущиеДанные = Объект.Выпуск.НайтиПоИдентификатору(ВыбраннаяСтрока);
	ПоказатьЗначение(, ТекущиеДанные.Распоряжение);
	
КонецПроцедуры
