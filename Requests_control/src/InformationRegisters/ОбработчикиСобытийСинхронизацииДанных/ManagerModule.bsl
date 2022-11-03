#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

// Процедура регистрирует необходимость выполнения обработчиков обновления информационной базы
// после получения данных из каждого периферийного узла РИБ.
//
Процедура ЗарегистрироватьОбновлениеДанныхИнформационнойБазы() Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	ПланыОбменаРИБ = СтандартныеПодсистемыПовтИсп.ПланыОбменаРИБ();
	Запрос = Новый Запрос();
	Запрос.УстановитьПараметр("ГлавныйУзел", ПланыОбмена.ГлавныйУзел());
	Для Каждого ИмяПланаОбмена Из ПланыОбменаРИБ Цикл
		Если СтрНайти(ОбменДаннымиСервер.НазначениеПланаОбмена(ИмяПланаОбмена), "РИБ") = 0 Тогда
			Продолжить;
		КонецЕсли;
		
		Запрос.Текст =
		"ВЫБРАТЬ
		|	ПланОбмена.Ссылка КАК Ссылка
		|ИЗ
		|	ПланОбмена.[ИмяПланаОбмена] КАК ПланОбмена
		|ГДЕ
		|	Не ПланОбмена.ЭтотУзел
		|	И НЕ ПланОбмена.ПометкаУдаления
		|	И ПланОбмена.Ссылка <> &ГлавныйУзел";
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "[ИмяПланаОбмена]", ИмяПланаОбмена);
		ВыборкаУзлов = Запрос.Выполнить().Выбрать();
		Пока ВыборкаУзлов.Следующий() Цикл
			
			СтруктураЗаписи = Новый Структура;
			СтруктураЗаписи.Вставить("УзелИнформационнойБазы", ВыборкаУзлов.Ссылка);
			СтруктураЗаписи.Вставить("Событие", "ПослеПолученияДанных");
			СтруктураЗаписи.Вставить("Обработчик", "ОбновлениеИнформационнойБазы");
			ОбменДаннымиСервер.ДобавитьЗаписьВРегистрСведений(СтруктураЗаписи, "ОбработчикиСобытийСинхронизацииДанных");
			
		КонецЦикла;
	КонецЦикла;
	
	
КонецПроцедуры

// Процедура выполняет обработчики, зарегистрированные для событий узлов планов обмена.
//
// Параметры:
//  УзелИнформационнойБазы - ПланОбменаСсылка - Узел информационной базы для выполнения обработчиков.
//  Событие - Строка - Имя события, для которого необходимо выполнить обработчики.
//
Процедура ВыполнитьОбработчики(УзелИнформационнойБазы, Событие) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	Обработчики.Обработчик
	|ИЗ
	|	РегистрСведений.ОбработчикиСобытийСинхронизацииДанных КАК Обработчики
	|ГДЕ
	|	Обработчики.УзелИнформационнойБазы = &УзелИнформационнойБазы
	|	И Обработчики.Событие = &Событие";
	
	Запрос.УстановитьПараметр("УзелИнформационнойБазы", УзелИнформационнойБазы);
	Запрос.УстановитьПараметр("Событие", Событие);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		
		Если Выборка.Обработчик = "ОбновлениеИнформационнойБазы" Тогда
			
			ОбновлениеИнформационнойБазыСлужебный.ПриПолученииПервогоСообщенияОбменаРИБПослеОбновления();
			
			СтруктураЗаписи = Новый Структура;
			СтруктураЗаписи.Вставить("УзелИнформационнойБазы", УзелИнформационнойБазы);
			СтруктураЗаписи.Вставить("Событие", "ПослеПолученияДанных");
			СтруктураЗаписи.Вставить("Обработчик", "ОбновлениеИнформационнойБазы");
			ОбменДаннымиСервер.УдалитьНаборЗаписейВРегистреСведений(СтруктураЗаписи, "ОбработчикиСобытийСинхронизацииДанных");
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли