
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Справочники.ИдентификаторыОбъектовМетаданных.ФормаСпискаПриСозданииНаСервере(ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокВыборЗначения(Элемент, Значение, СтандартнаяОбработка)
	
	СтандартныеПодсистемыКлиент.ИдентификаторыОбъектовМетаданныхФормаСпискаСписокВыборЗначения(ЭтотОбъект,
		Элемент, Значение, СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти
