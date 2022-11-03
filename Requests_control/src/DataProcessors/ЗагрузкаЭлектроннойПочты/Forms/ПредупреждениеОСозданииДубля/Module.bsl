&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ЗаголовокНадписи = "";
	Если Параметры.Документы.Количество() = 1 Тогда
		ЗаголовокНадписи = НСтр("ru = 'Письмо уже было загружено в документ:'");
	Иначе
		ЗаголовокНадписи = НСтр("ru = 'Письмо уже было загружено в документы:'");
	КонецЕсли;
	Элементы.Надпись.Заголовок = ЗаголовокНадписи;
	
	Для каждого Документ Из Параметры.Документы Цикл
		Если Не ЗначениеЗаполнено(Документ1) Тогда
			Документ1 = Документ;
			Документ1Заголовок = ПредставлениеДокумента(Документ1);
		ИначеЕсли Не ЗначениеЗаполнено(Документ2) Тогда
			Документ2 = Документ;
			Документ2Заголовок = ПредставлениеДокумента(Документ2);
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Функция ПредставлениеДокумента(Ссылка)
	Возврат Строка(Ссылка) + " (" + Ссылка.Метаданные().ПредставлениеОбъекта + ")";
КонецФункции
	
&НаКлиенте
Процедура СоздатьЕщеДокумент(Команда)
	Закрыть(Истина);
КонецПроцедуры

&НаКлиенте
Процедура ДокументНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Если Элемент = Элементы.Документ1 Тогда
		ПоказатьЗначение(, Документ1);
	ИначеЕсли Элемент = Элементы.Документ2 Тогда
		ПоказатьЗначение(, Документ2);
	КонецЕсли;
	
КонецПроцедуры
