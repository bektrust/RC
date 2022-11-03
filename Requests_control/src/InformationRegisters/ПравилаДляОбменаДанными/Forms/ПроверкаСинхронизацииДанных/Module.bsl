#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПерейтиКСписку(Команда)
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ПланыОбменаСПравиламиИзФайла", Истина);
	
	ОткрытьФорму("РегистрСведений.ПравилаДляОбменаДанными.Форма.ФормаСписка", ПараметрыФормы);
КонецПроцедуры

&НаКлиенте
Процедура ЗакрытьФорму(Команда)
	Закрыть();
КонецПроцедуры

&НаКлиенте
Процедура Проверено(Команда)
	ОтметитьВыполнениеДела();
	Закрыть();
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ОтметитьВыполнениеДела()
	
	ВерсияМассив  = СтрРазделить(Метаданные.Версия, ".");
	ТекущаяВерсия = ВерсияМассив[0] + ВерсияМассив[1] + ВерсияМассив[2];
	ХранилищеОбщихНастроек.Сохранить("ТекущиеДела", "ПланыОбмена", ТекущаяВерсия);
	
КонецПроцедуры

#КонецОбласти