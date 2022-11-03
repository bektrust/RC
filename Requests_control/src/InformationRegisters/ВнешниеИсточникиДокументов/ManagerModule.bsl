// Запоминает связь загруженного документа с внешним идентификатором,
// например идентификатором письма, в регистре сведений ВнешниеИсточникиДокументов
//
// Параметры:
// - Документ (ВходящийДокумент, ИсходящийДокумент, ВнутреннийДокумент, ВходящийДокумент)
// - Идентификатор (Строка)
//
Процедура ЗарегистрироватьВнешнийИсточникДокумента(Документ, Идентификатор) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	Если ПустаяСтрока(Идентификатор) Тогда
		Возврат;
	КонецЕсли;
	Если Не ЗначениеЗаполнено(Документ) Тогда
		Возврат;
	КонецЕсли;
	
	Запись = РегистрыСведений.ВнешниеИсточникиДокументов.СоздатьМенеджерЗаписи();
	Запись.Идентификатор = Идентификатор;
	Запись.Документ = Документ;
	Запись.Прочитать();
	Запись.Идентификатор = Идентификатор;
	Запись.Документ = Документ;
	Запись.Записать(Истина);
	
КонецПроцедуры
