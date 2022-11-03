#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

// Для внутреннего использования.
//
Процедура ВыполнитьЗагрузкуСправочников(Параметры, АдресВременногоХранилища) Экспорт
	
	ПараметрыОбменаДанными = ОбменДаннымиСервер.ПараметрыОбменаДаннымиЧерезФайлИлиСтроку();
	
	ПараметрыОбменаДанными.УзелИнформационнойБазы        = Параметры.УзелИнформационнойБазы;
	ПараметрыОбменаДанными.ПолноеИмяФайлаСообщенияОбмена = Параметры.ИмяФайлаСообщенияОбмена;
	ПараметрыОбменаДанными.ДействиеПриОбмене             = Перечисления.ДействияПриОбмене.ЗагрузкаДанных;
	
	ОбменДаннымиСервер.ВыполнитьОбменДаннымиДляУзлаИнформационнойБазыЧерезФайлИлиСтроку(ПараметрыОбменаДанными);
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли