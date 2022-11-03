
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Не ПолучитьФункциональнуюОпцию("УчитыватьВидыОбращений") Тогда 
		Элементы.ВидОбращения.Видимость = Ложь;
		Запись.ВидОбращения = Неопределено;
	КонецЕсли;
	
	Если Запись.СпособНумерации = ПредопределенноеЗначение("Перечисление.СпособыНумерации.Вручную")
		Или Запись.СпособНумерации = ПредопределенноеЗначение("Перечисление.СпособыНумерации.ПустаяСсылка") Тогда 
		Элементы.Нумератор.Доступность = Ложь;
	Иначе 
		Элементы.Нумератор.Доступность = Истина;
		Элементы.Нумератор.АвтоОтметкаНезаполненного = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СпособНумерацииПриИзменении(Элемент)
	
	Если Запись.СпособНумерации = ПредопределенноеЗначение("Перечисление.СпособыНумерации.Вручную") Тогда 
		Элементы.Нумератор.Доступность = Ложь;
		Запись.Нумератор = Неопределено;
	ИначеЕсли Запись.СпособНумерации = ПредопределенноеЗначение("Перечисление.СпособыНумерации.Автоматически") Тогда  
		Элементы.Нумератор.Доступность = Истина;
		Элементы.Нумератор.АвтоОтметкаНезаполненного = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	Если Запись.СпособНумерации = ПредопределенноеЗначение("Перечисление.СпособыНумерации.Автоматически") 
		И Не ЗначениеЗаполнено(Запись.Нумератор) Тогда 
		ТекстОшибки = НСтр("ru = 'Поле ""Нумератор"" не заполнено'");
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки,,
			"Запись.Нумератор",, Отказ);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НумераторОткрытие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ПараметрыОткрытия = Новый Структура("Ключ, ВидОбращения", Запись.Нумератор, Запись.ВидОбращения);
	ОткрытьФорму("Справочник.Нумераторы.ФормаОбъекта", ПараметрыОткрытия, Элемент);
	
КонецПроцедуры
