////////////////////////////////////////////////////////////////////////////////
// Подсистема "Запрет редактирования реквизитов объектов".
// 
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Определить объекты метаданных, в модулях менеджеров которых ограничивается возможность редактирования реквизитов
// с помощью экспортной функции ПолучитьБлокируемыеРеквизитыОбъекта.
//
// Параметры:
//   Объекты - Соответствие - в качестве ключа указать полное имя объекта метаданных,
//                            подключенного к подсистеме "Запрет редактирования реквизитов объектов";
//                            В качестве значения - пустую строку.
//
// Пример: 
//   Объекты.Вставить(Метаданные.Документы.ЗаказПокупателя.ПолноеИмя(), "");
//
Процедура ПриОпределенииОбъектовСЗаблокированнымиРеквизитами(Объекты) Экспорт
	
	Объекты.Вставить(Метаданные.Справочники.Разделы.ПолноеИмя(), "");
	Объекты.Вставить(Метаданные.Справочники.Тематики.ПолноеИмя(), "");
	Объекты.Вставить(Метаданные.Справочники.Темы.ПолноеИмя(), "");
	Объекты.Вставить(Метаданные.Справочники.Вопросы.ПолноеИмя(), "");
	
КонецПроцедуры

#КонецОбласти
