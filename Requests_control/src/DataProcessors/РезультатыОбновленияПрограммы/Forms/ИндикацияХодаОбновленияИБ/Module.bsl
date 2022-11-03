&НаКлиенте
Перем ПараметрыПродолжения;

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ВыполняетсяОбновлениеВерсииИБ = Истина;
	ВремяНачалаОбновления = ТекущаяДатаСеанса();
	
	НачалоШагаПрогресса = 5;
	ДлинаШагаПрогресса  = 5;
	ПрогрессВыполнения = НачалоШагаПрогресса;
	
	РежимОбновленияДанных = ОбновлениеИнформационнойБазыСлужебный.РежимОбновленияДанных();
	
	ТолькоОбновлениеПараметровРаботыПрограммы =
		Не ОбновлениеИнформационнойБазы.НеобходимоОбновлениеИнформационнойБазы();
	
	Если ТолькоОбновлениеПараметровРаботыПрограммы Тогда
		Заголовок = НСтр("ru = 'Обновление параметров работы программы'");
		Элементы.РежимЗапуска.ТекущаяСтраница = Элементы.ОбновлениеПараметровРаботыПрограммы;
		ДлинаШагаПрогресса = 95;
		
	ИначеЕсли РежимОбновленияДанных = "НачальноеЗаполнение" Тогда
		Заголовок = НСтр("ru = 'Начальное заполнение данных'");
		Элементы.РежимЗапуска.ТекущаяСтраница = Элементы.НачальноеЗаполнение;
		
	ИначеЕсли РежимОбновленияДанных = "ПереходСДругойПрограммы" Тогда
		Заголовок = НСтр("ru = 'Переход с другой программы'");
		Элементы.РежимЗапуска.ТекущаяСтраница = Элементы.ПереходСДругойПрограммы;
		Элементы.ТекстСообщенияПереходСДругойПрограммы.Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			Элементы.ТекстСообщенияПереходСДругойПрограммы.Заголовок, Метаданные.Синоним);
	Иначе
		Заголовок = НСтр("ru = 'Обновление версии программы'");
		Элементы.РежимЗапуска.ТекущаяСтраница = Элементы.ОбновлениеВерсииПрограммы;
		Элементы.ТекстСообщенияОбновляемаяКонфигурация.Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			Элементы.ТекстСообщенияОбновляемаяКонфигурация.Заголовок, Метаданные.Синоним, Метаданные.Версия);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если ОбщегоНазначенияДокументооборотКлиент.ПередЗакрытием(
		Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка, Модифицированность) Тогда
		Возврат;
	КонецЕсли;
	
	Если ВыполняетсяОбновлениеВерсииИБ Тогда
		Отказ = Истина;
	ИначеЕсли МонопольныйРежимУстановлен Тогда
		СнятьМонопольныйРежим();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ТехническаяИнформацияНажатие(Элемент)
	ПараметрыОтбора = Новый Структура;
	ПараметрыОтбора.Вставить("ЗапускатьНеВФоне", Истина);
	
	ОткрытьФорму("Обработка.ЖурналРегистрации.Форма.ЖурналРегистрации", ПараметрыОтбора);
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

////////////////////////////////////////////////////////////////////////////////
// Обновление параметров работы программы и неразделенных данных в сервисе.

&НаСервереБезКонтекста
Процедура СнятьМонопольныйРежим()
	
	Если МонопольныйРежим() Тогда
		УстановитьМонопольныйРежим(Ложь);
	КонецЕсли;
	
	МонопольныйРежимУстановлен = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьОбновитьПараметрыРаботыПрограммы(Параметры) Экспорт
	
	ПараметрыПродолжения = Параметры;
	
	ПодключитьОбработчикОжидания("ЗагрузитьОбновитьПараметрыРаботыПрограммыНачало", 0.1, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьОбновитьПараметрыРаботыПрограммыНачало()
	
	// Параметры обработчика длительной операции.
	ПараметрыОбработчика = Новый Структура;
	ПараметрыОбработчика.Вставить("МинимальныйИнтервал", 1);
	ПараметрыОбработчика.Вставить("МаксимальныйИнтервал", 15);
	ПараметрыОбработчика.Вставить("ТекущийИнтервал", 1);
	ПараметрыОбработчика.Вставить("КоэффициентУвеличенияИнтервала", 1.4);
	
	ФоновоеЗаданиеАдресХранилища = Неопределено;
	ФоновоеЗаданиеИдентификатор  = Неопределено;
	
	РезультатВыполнения = ЗагрузитьОбновитьПараметрыРаботыПрограммыВФоне();
	
	Если РезультатВыполнения.ЗаданиеВыполнено
	 Или РезультатВыполнения.КраткоеСообщениеОбОшибке <> Неопределено Тогда
		
		ЗагрузитьОбновитьПараметрыРаботыПрограммыОбработатьРезультат(
			РезультатВыполнения.КраткоеСообщениеОбОшибке,
			РезультатВыполнения.ПодробноеСообщениеОбОшибке);
	Иначе
		ПодключитьОбработчикОжидания("ОбновлениеПараметровРаботыПрограммыПроверитьНаКлиенте", 1, Истина);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ЗагрузитьОбновитьПараметрыРаботыПрограммыВФоне()
	
	ОбновитьПовторноИспользуемыеЗначения();
	
	ИнформацияОбОшибке = Неопределено;
	
	Попытка
		УстановитьМонопольныйРежим(Истина);
		МонопольныйРежимУстановлен = Истина;
	Исключение
		// Вызов исключения не требуется, т.к. необходимость установки
		// монопольного режима выясняется лишь в ходе выполнения фонового обновления.
		// Поэтому предварительная установка монопольного режима сокращает лишний запуск
		// фонового задания в тех случаях, когда монопольный режим потребуется, но может
		// быть установлен сразу без завершения сеансов пользователей.
	КонецПопытки;
	
	// Запуск фонового задания
	РежимОтладки = ОбщегоНазначенияКлиентСервер.РежимОтладки();
	ПараметрыВыполнения = Новый Структура;
	Если Не РежимОтладки Тогда
		ПараметрыВыполнения.Вставить("ПараметрыКлиентаНаСервере", ПараметрыСеанса.ПараметрыКлиентаНаСервере);
		ПараметрыВыполнения.Вставить("УстановленныеРасширения",   ПараметрыСеанса.УстановленныеРасширения);
		ПараметрыВыполнения.Вставить("ХранилищеСвойствРасширений",
			Справочники.ИдентификаторыОбъектовМетаданных.ХранилищеСвойствРасширений());
	КонецЕсли;
	
	Попытка
		Результат = ДлительныеОперации.ЗапуститьВыполнениеВФоне(
			УникальныйИдентификатор,
			"СтандартныеПодсистемыСервер.ЗагрузитьОбновитьПараметрыРаботыПрограммыВФоне",
			ПараметрыВыполнения,
			НСтр("ru = 'Фоновое обновление параметров работы программы'"));
		
		Результат.Вставить("КраткоеСообщениеОбОшибке",   Неопределено);
		Результат.Вставить("ПодробноеСообщениеОбОшибке", Неопределено);
	Исключение
		ИнформацияОбОшибке = ИнформацияОбОшибке();
		Результат = Новый Структура;
		Результат.Вставить("ЗаданиеВыполнено", Ложь);
		Результат.Вставить("КраткоеСообщениеОбОшибке",   КраткоеПредставлениеОшибки(ИнформацияОбОшибке));
		Результат.Вставить("ПодробноеСообщениеОбОшибке", ПодробноеПредставлениеОшибки(ИнформацияОбОшибке));
	КонецПопытки;
	
	Результат.Свойство("ИдентификаторЗадания", ФоновоеЗаданиеИдентификатор);
	Результат.Свойство("АдресХранилища", ФоновоеЗаданиеАдресХранилища);
	
	Возврат Результат;
	
КонецФункции

&НаКлиенте
Процедура ЗагрузитьОбновитьПараметрыРаботыПрограммыОбработатьРезультат(Знач КраткоеСообщениеОбОшибке, Знач ПодробноеСообщениеОбОшибке)
	
	ОшибкаУстановкиМонопольногоРежима = "";
	
	Если КраткоеСообщениеОбОшибке = Неопределено Тогда
		РезультатВыполнения = ПолучитьИзВременногоХранилища(ФоновоеЗаданиеАдресХранилища);
		
		Если ТипЗнч(РезультатВыполнения) = Тип("Структура") Тогда
			КраткоеСообщениеОбОшибке   = РезультатВыполнения.КраткоеСообщениеОбОшибке;
			ПодробноеСообщениеОбОшибке = РезультатВыполнения.ПодробноеСообщениеОбОшибке;
			ОшибкаУстановкиМонопольногоРежима = РезультатВыполнения.ОшибкаУстановкиМонопольногоРежима;
			
			Если РезультатВыполнения.Свойство("ПараметрыКлиентаНаСервере") Тогда
				УстановитьПараметрыСеансаИзФоновогоЗадания();
			КонецЕсли;
		Иначе
			КраткоеСообщениеОбОшибке =
				НСтр("ru = 'Ошибка получения результата от фонового задания
				           |при обновлении параметров работы программы.'");
			
			ПодробноеСообщениеОбОшибке = КраткоеСообщениеОбОшибке;
		КонецЕсли;
	КонецЕсли;
	
	Если ОшибкаУстановкиМонопольногоРежима = "ЗаблокироватьВыполнениеРегламентныхЗаданий" Тогда
		ПерезапускСБлокировкойВыполненияРегламентныхЗаданий();
	КонецЕсли;
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("КраткоеСообщениеОбОшибке",   КраткоеСообщениеОбОшибке);
	ДополнительныеПараметры.Вставить("ПодробноеСообщениеОбОшибке", ПодробноеСообщениеОбОшибке);
	ДополнительныеПараметры.Вставить("ОшибкаУстановкиМонопольногоРежима", ОшибкаУстановкиМонопольногоРежима);
	
	Если ЗначениеЗаполнено(ОшибкаУстановкиМонопольногоРежима) Тогда
		
		ЗагрузитьОбновитьПараметрыРаботыПрограммыПриОшибкеУстановкиМонопольногоРежима(ДополнительныеПараметры);
		Возврат;
		
	КонецЕсли;
	
	ЗагрузитьОбновитьПараметрыРаботыПрограммыЗавершение(ДополнительныеПараметры);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьОбновитьПараметрыРаботыПрограммыПриОшибкеУстановкиМонопольногоРежима(ДополнительныеПараметры)
	
	Если ЗначениеЗаполнено(ДополнительныеПараметры.ОшибкаУстановкиМонопольногоРежима) Тогда
		
		// Открытие формы для отключения активных сеансов.
		Оповещение = Новый ОписаниеОповещения(
			"ЗагрузитьОбновитьПараметрыРаботыПрограммыПриОшибкеУстановкиМонопольногоРежимаЗавершение",
			ЭтотОбъект,
			ДополнительныеПараметры);
		
		ПриОткрытииФормыОшибкиУстановкиМонопольногоРежима(Оповещение, ДополнительныеПараметры);
	Иначе
		ЗагрузитьОбновитьПараметрыРаботыПрограммыЗавершение(ДополнительныеПараметры);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьОбновитьПараметрыРаботыПрограммыПриОшибкеУстановкиМонопольногоРежимаЗавершение(Отказ, ДополнительныеПараметры) Экспорт
	
	Если Отказ <> Ложь Тогда
		Если БлокировкаИБ <> Неопределено
			И БлокировкаИБ.Свойство("СнятьБлокировкуФайловойБазы") Тогда
			ОбновлениеИнформационнойБазыСлужебныйВызовСервера.СнятьБлокировкуФайловойБазы();
		КонецЕсли;
		ЗакрытьФорму(Истина, Ложь);
		Возврат;
	КонецЕсли;
	
	УстановитьПараметрыБлокировкиИБПриОшибкеУстановкиМонопольногоРежима();
	ЗагрузитьОбновитьПараметрыРаботыПрограммыНачало();
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьОбновитьПараметрыРаботыПрограммыЗавершение(ДополнительныеПараметры)
	
	Если ДополнительныеПараметры.КраткоеСообщениеОбОшибке <> Неопределено Тогда
		СообщениеОНеудачномОбновлении(ДополнительныеПараметры, Неопределено);
		Возврат;
	КонецЕсли;
	
	ПараметрыПродолжения.ПолученныеПараметрыКлиента.Вставить("НеобходимоОбновлениеПараметровРаботыПрограммы");
	ПараметрыПродолжения.Вставить("КоличествоПолученныхПараметровКлиента",
		ПараметрыПродолжения.ПолученныеПараметрыКлиента.Количество());
	ОбновитьПовторноИспользуемыеЗначения();
	
	Попытка
		ПараметрыКлиента = СтандартныеПодсистемыКлиентПовтИсп.ПараметрыРаботыКлиентаПриЗапуске();
	Исключение
		ИнформацияОбОшибке = ИнформацияОбОшибке();
		ДополнительныеПараметры.Вставить("КраткоеСообщениеОбОшибке", КраткоеПредставлениеОшибки(ИнформацияОбОшибке));
		ДополнительныеПараметры.Вставить("ПодробноеСообщениеОбОшибке", ПодробноеПредставлениеОшибки(ИнформацияОбОшибке));
		СообщениеОНеудачномОбновлении(ДополнительныеПараметры, Неопределено);
		Возврат;
	КонецПопытки;
	
	Если Не ТолькоОбновлениеПараметровРаботыПрограммы
	   И ПараметрыКлиента.ДоступноИспользованиеРазделенныхДанных Тогда
		
		ВыполнитьОбработкуОповещения(ПараметрыПродолжения.ОбработкаПродолжения);
	Иначе
		Если ПараметрыКлиента.Свойство("НеобходимоОбновлениеНеразделенныхДанныхИнформационнойБазы") Тогда
			Попытка
				ОбновлениеИнформационнойБазыСлужебныйВызовСервера.ВыполнитьОбновлениеИнформационнойБазы(Истина);
			Исключение
				ИнформацияОбОшибке = ИнформацияОбОшибке();
				ДополнительныеПараметры.Вставить("КраткоеСообщениеОбОшибке",   КраткоеПредставлениеОшибки(ИнформацияОбОшибке));
				ДополнительныеПараметры.Вставить("ПодробноеСообщениеОбОшибке", ПодробноеПредставлениеОшибки(ИнформацияОбОшибке));
			КонецПопытки;
			Если ДополнительныеПараметры.КраткоеСообщениеОбОшибке <> Неопределено Тогда
				СообщениеОНеудачномОбновлении(ДополнительныеПараметры, Неопределено);
				Возврат;
			КонецЕсли;
		КонецЕсли;
		
		Если БлокировкаИБ <> Неопределено
			И БлокировкаИБ.Свойство("СнятьБлокировкуФайловойБазы") Тогда
			ОбновлениеИнформационнойБазыСлужебныйВызовСервера.СнятьБлокировкуФайловойБазы();
		КонецЕсли;
		ЗакрытьФорму(Ложь, Ложь);
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Процедуры получения результата выполнения обработчиков обновления.

&НаКлиенте
Процедура ОбновлениеПараметровРаботыПрограммыПроверитьНаКлиенте()
	
	Результат = ОбновлениеПараметровРаботыПрограммыВыполнено();
	
	Если Результат.ЗаданиеВыполнено = Истина
	 Или Результат.КраткоеСообщениеОбОшибке <> Неопределено Тогда
		
		ЗагрузитьОбновитьПараметрыРаботыПрограммыОбработатьРезультат(
			Результат.КраткоеСообщениеОбОшибке, Результат.ПодробноеСообщениеОбОшибке);
	Иначе
		ДлительныеОперацииКлиент.ОбновитьПараметрыОбработчикаОжидания(ПараметрыОбработчика);
		ПодключитьОбработчикОжидания("ОбновлениеПараметровРаботыПрограммыПроверитьНаКлиенте", ПараметрыОбработчика.ТекущийИнтервал, Истина);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ОбновлениеПараметровРаботыПрограммыВыполнено()
	
	ИнформацияОбОшибке = Неопределено;
	ЗаданиеВыполнено = Ложь;
	
	ПродвинутьИндикаторПрогресса(ЗаданиеВыполнено, ИнформацияОбОшибке);
	
	Результат = Новый Структура;
	Результат.Вставить("ЗаданиеВыполнено", ЗаданиеВыполнено);
	Результат.Вставить("КраткоеСообщениеОбОшибке",   ?(ИнформацияОбОшибке <> Неопределено, КраткоеПредставлениеОшибки(ИнформацияОбОшибке), Неопределено));
	Результат.Вставить("ПодробноеСообщениеОбОшибке", ?(ИнформацияОбОшибке <> Неопределено, ПодробноеПредставлениеОшибки(ИнформацияОбОшибке), Неопределено));
	Результат.Вставить("ПрогрессВыполнения", ПрогрессВыполнения);
	
	Возврат Результат;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Обновление информационной базы (все в локальном режиме и область данных в сервисе).

&НаКлиенте
Процедура ОбновитьИнформационнуюБазу() Экспорт
	
	НачалоШагаПрогресса = 10;
	ДлинаШагаПрогресса  = 5;
	ПрогрессВыполнения = НачалоШагаПрогресса;
	
	ПодключитьОбработчикОжидания("ОбновитьИнформационнуюБазуНачало", 0.1, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьИнформационнуюБазуНачало()
	
	ВремяНачалаОбновления = ОбщегоНазначенияКлиент.ДатаСеанса();
	
	// Параметры обработчика длительной операции.
	ПараметрыОбработчика = Новый Структура;
	ПараметрыОбработчика.Вставить("МинимальныйИнтервал", 1);
	ПараметрыОбработчика.Вставить("МаксимальныйИнтервал", 15);
	ПараметрыОбработчика.Вставить("ТекущийИнтервал", 1);
	ПараметрыОбработчика.Вставить("КоэффициентУвеличенияИнтервала", 1.4);
	
	ФоновоеЗаданиеАдресХранилища = Неопределено;
	ФоновоеЗаданиеИдентификатор = Неопределено;
	
	РезультатОбновленияИБ = ОбновитьИнформационнуюБазуВФоне();
	
	Если ПараметрыНачалаРаботы <> Неопределено 
		И ПараметрыНачалаРаботы.Свойство("ОбновитьКлассификатор")
		И ПараметрыНачалаРаботы.ОбновитьКлассификатор = Ложь Тогда 
		ПараметрыНачалаРаботы.Вставить("ОбновлениеВерсииПрограммы", Истина);
		
	КонецЕсли;
	
	Если РезультатОбновленияИБ.ЗаданиеВыполнено
	 Или РезультатОбновленияИБ.КраткоеСообщениеОбОшибке <> Неопределено Тогда
		
		ОбновитьИнформационнуюБазуОбработатьРезультат(
			РезультатОбновленияИБ.КраткоеСообщениеОбОшибке,
			РезультатОбновленияИБ.ПодробноеСообщениеОбОшибке);
	Иначе
		ПодключитьОбработчикОжидания("ОбновлениеИнформационнойБазыПроверитьНаКлиенте", 1, Истина);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ОбновитьИнформационнуюБазуВФоне()
	
	ЗаписьЖурналаРегистрации("Запись константы", УровеньЖурналаРегистрации.Предупреждение,,, "Попали в процедуру");
	Результат = ОбновлениеИнформационнойБазыСлужебный.ОбновитьИнформационнуюБазуВФоне(УникальныйИдентификатор, БлокировкаИБ);
	БлокировкаИБ = Результат.БлокировкаИБ;
	Результат.Свойство("ИдентификаторЗадания", ФоновоеЗаданиеИдентификатор);
	Результат.Свойство("АдресХранилища", ФоновоеЗаданиеАдресХранилища);
	
	//Если Не Результат.Свойство("АктуализироватьКлассификатор") Тогда 
	//	Результат.Вставить("АктуализироватьКлассификатор", Константы.АктуализироватьКлассификатор.Получить());
	//	ЗаписьЖурналаРегистрации("Запись константы", УровеньЖурналаРегистрации.Предупреждение,,, "Попали в процедуру 1");
	//ИначеЕсли Результат.АктуализироватьКлассификатор = Ложь Тогда 
	//	Результат.АктуализироватьКлассификатор = Константы.АктуализироватьКлассификатор.Получить();
	//	ЗаписьЖурналаРегистрации("Запись константы", УровеньЖурналаРегистрации.Предупреждение,,, "Попали в процедуру 2");
	//КонецЕсли;
	//
	//ЗаписьЖурналаРегистрации("Запись константы", УровеньЖурналаРегистрации.Предупреждение,,, "Попали в процедуру 3" 
	//	+ СокрЛП(Константы.АктуализироватьКлассификатор.Получить()) + " " + СокрЛП(Результат.АктуализироватьКлассификатор));
	
	Возврат Результат;
	
КонецФункции

&НаКлиенте
Процедура ОбновитьИнформационнуюБазуОбработатьРезультат(Знач КраткоеСообщениеОбОшибке, Знач ПодробноеСообщениеОбОшибке)
	
	Если ФоновоеЗаданиеАдресХранилища <> "" Тогда
		РезультатОбновления = ПолучитьИзВременногоХранилища(ФоновоеЗаданиеАдресХранилища);
		
		Если ТипЗнч(РезультатОбновления) = Тип("Структура") Тогда
			Если РезультатОбновления.Свойство("КраткоеСообщениеОбОшибке")
				И РезультатОбновления.Свойство("ПодробноеСообщениеОбОшибке") Тогда
				КраткоеСообщениеОбОшибке = РезультатОбновления.КраткоеСообщениеОбОшибке;
				ПодробноеСообщениеОбОшибке = РезультатОбновления.ПодробноеСообщениеОбОшибке;
			Иначе
				ПризнакВыполненияОбработчиков = РезультатОбновления.Результат;
				УстановитьПараметрыСеансаИзФоновогоЗадания();
			КонецЕсли;
		Иначе
			ПризнакВыполненияОбработчиков = РезультатОбновления;
		КонецЕсли;
	Иначе
		ПризнакВыполненияОбработчиков = БлокировкаИБ.Ошибка;
	КонецЕсли;
	
	Если ПризнакВыполненияОбработчиков = "ЗаблокироватьВыполнениеРегламентныхЗаданий" Тогда
		ПерезапускСБлокировкойВыполненияРегламентныхЗаданий();
	КонецЕсли;
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ДокументОписаниеОбновлений", Неопределено);
	ДополнительныеПараметры.Вставить("КраткоеСообщениеОбОшибке", КраткоеСообщениеОбОшибке);
	ДополнительныеПараметры.Вставить("ПодробноеСообщениеОбОшибке", ПодробноеСообщениеОбОшибке);
	ДополнительныеПараметры.Вставить("ВремяНачалаОбновления", ВремяНачалаОбновления);
	ДополнительныеПараметры.Вставить("ВремяОкончанияОбновления", ОбщегоНазначенияКлиент.ДатаСеанса());
	ДополнительныеПараметры.Вставить("ПризнакВыполненияОбработчиков", ПризнакВыполненияОбработчиков);
	
	Если ПризнакВыполненияОбработчиков = "ОшибкаУстановкиМонопольногоРежима" Тогда
		
		ОбновитьИнформационнуюБазуПриОшибкеУстановкиМонопольногоРежима(ДополнительныеПараметры);
		Возврат;
		
	КонецЕсли;
	
	СнятьБлокировкуФайловойБазы = Ложь;
	Если БлокировкаИБ.Свойство("СнятьБлокировкуФайловойБазы", СнятьБлокировкуФайловойБазы) Тогда
		
		Если СнятьБлокировкуФайловойБазы Тогда
			ОбновлениеИнформационнойБазыСлужебныйВызовСервера.СнятьБлокировкуФайловойБазы();
		КонецЕсли;
		
	КонецЕсли;
	
	ОбновитьИнформационнуюБазуЗавершение(ДополнительныеПараметры);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьИнформационнуюБазуПриОшибкеУстановкиМонопольногоРежима(ДополнительныеПараметры)
	
	Если ДополнительныеПараметры.ПризнакВыполненияОбработчиков = "ОшибкаУстановкиМонопольногоРежима" Тогда
		
		// Открытие формы для отключения активных сеансов.
		Оповещение = Новый ОписаниеОповещения(
			"ОбновитьИнформационнуюБазуПриОшибкеУстановкиМонопольногоРежимаЗавершение", ЭтотОбъект, ДополнительныеПараметры);
		ПриОткрытииФормыОшибкиУстановкиМонопольногоРежима(Оповещение, ДополнительныеПараметры);
		
	Иначе
		ОбновитьИнформационнуюБазуЗавершение(ДополнительныеПараметры);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьИнформационнуюБазуПриОшибкеУстановкиМонопольногоРежимаЗавершение(Отказ, ДополнительныеПараметры) Экспорт
	
	Если Отказ <> Ложь Тогда
		ЗакрытьФорму(Истина, Ложь);
		Возврат;
	КонецЕсли;
	
	УстановитьПараметрыБлокировкиИБПриОшибкеУстановкиМонопольногоРежима();
	ОбновитьИнформационнуюБазуНачало();
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьПараметрыБлокировкиИБПриОшибкеУстановкиМонопольногоРежима()
	
	Если БлокировкаИБ = Неопределено Тогда
		БлокировкаИБ = Новый Структура;
	КонецЕсли;
	
	БлокировкаИБ.Вставить("Установлена", Ложь);
	БлокировкаИБ.Вставить("СнятьБлокировкуФайловойБазы", Истина);
	БлокировкаИБ.Вставить("Ошибка", Неопределено);
	БлокировкаИБ.Вставить("ОперативноеОбновление", Неопределено);
	БлокировкаИБ.Вставить("КлючЗаписи", Неопределено);
	БлокировкаИБ.Вставить("РежимОтладки", Неопределено);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьИнформационнуюБазуЗавершение(ДополнительныеПараметры)
	
	Если ДополнительныеПараметры.КраткоеСообщениеОбОшибке <> Неопределено Тогда
		ВремяОкончанияОбновления = ОбщегоНазначенияКлиент.ДатаСеанса();
		
		СообщениеОНеудачномОбновлении(ДополнительныеПараметры, ВремяОкончанияОбновления);
		Возврат;
	КонецЕсли;
	
	ОбновлениеИнформационнойБазыСлужебныйВызовСервера.ЗаписатьВремяВыполненияОбновления(
		ДополнительныеПараметры.ВремяНачалаОбновления, ДополнительныеПараметры.ВремяОкончанияОбновления);
	
	ОбновитьПовторноИспользуемыеЗначения();
	Если (СтандартныеПодсистемыКлиентПовтИсп.ПараметрыРаботыКлиента().ЭтоБазоваяВерсияКонфигурации
		Или СтандартныеПодсистемыКлиентПовтИсп.ПараметрыРаботыКлиентаПриЗапуске().ЭтоУчебнаяПлатформа)
		И СтрНайти(ПараметрЗапуска, "ВыполнитьОбновлениеИЗавершитьРаботу") > 0 Тогда
		ПрекратитьРаботуСистемы(Ложь);
	Иначе
		ЗакрытьФорму(Ложь, Ложь);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗакрытьФорму(Отказ, Перезапустить)
	
	ВыполняетсяОбновлениеВерсииИБ = Ложь;
	
	Закрыть(Новый Структура("Отказ, Перезапустить", Отказ, Перезапустить));
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Процедуры получения результата выполнения обработчиков обновления.

&НаКлиенте
Процедура ОбновлениеИнформационнойБазыПроверитьНаКлиенте()
	
	Результат = ОбновлениеИнформационнойБазыВыполнено();
	
	Если Результат.ЗаданиеВыполнено = Истина
	 Или Результат.КраткоеСообщениеОбОшибке <> Неопределено Тогда
		
		ОбновитьИнформационнуюБазуОбработатьРезультат(
			Результат.КраткоеСообщениеОбОшибке, Результат.ПодробноеСообщениеОбОшибке);
	Иначе
		ДлительныеОперацииКлиент.ОбновитьПараметрыОбработчикаОжидания(ПараметрыОбработчика);
		ПодключитьОбработчикОжидания("ОбновлениеИнформационнойБазыПроверитьНаКлиенте", ПараметрыОбработчика.ТекущийИнтервал, Истина);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ОбновлениеИнформационнойБазыВыполнено()
	
	ИнформацияОбОшибке = Неопределено;
	ЗаданиеВыполнено = Ложь;
	
	ПродвинутьИндикаторПрогресса(ЗаданиеВыполнено, ИнформацияОбОшибке);
	
	// Если обновление ИБ завершилось - разблокируем ИБ.
	Если ЗаданиеВыполнено = Истина Тогда
		ОбновлениеИнформационнойБазыСлужебный.РазблокироватьИБ(БлокировкаИБ);
	КонецЕсли;
	
	Результат = Новый Структура;
	Результат.Вставить("ЗаданиеВыполнено", ЗаданиеВыполнено);
	Результат.Вставить("КраткоеСообщениеОбОшибке",   ?(ИнформацияОбОшибке <> Неопределено, КраткоеПредставлениеОшибки(ИнформацияОбОшибке),   Неопределено));
	Результат.Вставить("ПодробноеСообщениеОбОшибке", ?(ИнформацияОбОшибке <> Неопределено, ПодробноеПредставлениеОшибки(ИнформацияОбОшибке), Неопределено));
	Результат.Вставить("ПрогрессВыполнения", ПрогрессВыполнения);
	
	Возврат Результат;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Обработчики условных вызовов в другие подсистемы.

// Вызывается при неудачной попытке установить монопольный режим в файловой базе.
// 
// Параметры:
//  Отказ - булево - если Истина - завершает работу программы.
//
&НаКлиенте
Процедура ПриОткрытииФормыОшибкиУстановкиМонопольногоРежима(Оповещение, ДополнительныеПараметры)
	
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.ЗавершениеРаботыПользователей") Тогда
		МодульСоединенияИБКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("СоединенияИБКлиент");
		МодульСоединенияИБКлиент.ПриОткрытииФормыОшибкиУстановкиМонопольногоРежима(Оповещение);
	Иначе
		СообщениеОНеудачномОбновлении(ДополнительныеПараметры, Неопределено);
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Общие процедуры для всех этапов.

&НаКлиенте
Процедура НачатьЗакрытие() Экспорт
	
	ПодключитьОбработчикОжидания("ПродолжитьЗакрытие", 0.1, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ПродолжитьЗакрытие() Экспорт
	
	ВыполняетсяОбновлениеВерсииИБ = Ложь;
	
	ЗакрытьФорму(Ложь, Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура СообщениеОНеудачномОбновлении(ДополнительныеПараметры, ВремяОкончанияОбновления)
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ОбновитьИнформационнуюБазуДействияПриОшибке", ЭтотОбъект);
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("КраткоеСообщениеОбОшибке",   ДополнительныеПараметры.КраткоеСообщениеОбОшибке);
	ПараметрыФормы.Вставить("ПодробноеСообщениеОбОшибке", ДополнительныеПараметры.ПодробноеСообщениеОбОшибке);
	ПараметрыФормы.Вставить("ВремяНачалаОбновления",      ВремяНачалаОбновления);
	ПараметрыФормы.Вставить("ВремяОкончанияОбновления",   ВремяОкончанияОбновления);
	
	ИмяОткрываемойФормы = "Обработка.РезультатыОбновленияПрограммы.Форма.СообщениеОНеудачномОбновлении";
	
	Если ЗначениеЗаполнено(ИмяПланаОбмена) Тогда
		
		МодульОбменДаннымиКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ОбменДаннымиКлиент");
		ИмяОткрываемойФормы = МодульОбменДаннымиКлиент.ИмяФормыСообщенияОНеудачномОбновлении();
		ПараметрыФормы.Вставить("ИмяПланаОбмена", ИмяПланаОбмена);
		
	КонецЕсли;
	
	ОткрытьФорму(ИмяОткрываемойФормы, ПараметрыФормы,,,,,ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьИнформационнуюБазуДействияПриОшибке(ЗавершитьРаботу, ДополнительныеПараметры) Экспорт
	
	Если БлокировкаИБ <> Неопределено
		И БлокировкаИБ.Свойство("СнятьБлокировкуФайловойБазы") Тогда
		ОбновлениеИнформационнойБазыСлужебныйВызовСервера.СнятьБлокировкуФайловойБазы();
	КонецЕсли;
	
	Если ЗавершитьРаботу <> Ложь Тогда
		ЗакрытьФорму(Истина, Ложь);
	Иначе
		ЗакрытьФорму(Истина, Истина);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПерезапускСБлокировкойВыполненияРегламентныхЗаданий()
	
	НовыйПараметрЗапуска = ПараметрЗапуска + ";РегламентныеЗаданияОтключены";
	НовыйПараметрЗапуска = "/AllowExecuteScheduledJobs -Off " + "/C """ + НовыйПараметрЗапуска + """";
	ПрекратитьРаботуСистемы(Истина, НовыйПараметрЗапуска);
	
КонецПроцедуры

&НаСервере
Процедура ПродвинутьИндикаторПрогресса(ЗаданиеВыполнено, ИнформацияОбОшибке)
	
	Если ФоновоеЗаданиеИдентификатор <> Неопределено Тогда
		
		Попытка
			ЗаданиеВыполнено = ДлительныеОперации.ЗаданиеВыполнено(ФоновоеЗаданиеИдентификатор);
			Задание = ФоновыеЗадания.НайтиПоУникальномуИдентификатору(ФоновоеЗаданиеИдентификатор);
			Если Задание <> Неопределено Тогда
				ВсеСообщения = Задание.ПолучитьСообщенияПользователю(Истина);
				Если ВсеСообщения <> Неопределено Тогда
					ПрибавкаНаШагеПрогресса = 0;
					Для каждого СообщениеПользователю Из ВсеСообщения Цикл
						ВсеСообщения = Задание.ПолучитьСообщенияПользователю(Истина);
						Если ВсеСообщения = Неопределено Тогда
							ВсеСообщения = Новый Массив;
						КонецЕсли;
						
						НачалоСтроки = "ШагПрогресса=";
						Если СтрНачинаетсяС(СообщениеПользователю.Текст, НачалоСтроки) Тогда
							ПрибавкаНаШагеПрогресса = 0;
							ОписаниеНовогоШага = Сред(СообщениеПользователю.Текст, СтрДлина(НачалоСтроки) + 1);
							ПозицияРазделителя = СтрНайти(ОписаниеНовогоШага, "/");
							Если ПозицияРазделителя > 0 Тогда
								НачалоШагаПрогресса = Число( Лев(ОписаниеНовогоШага, ПозицияРазделителя - 1));
								ДлинаШагаПрогресса  = Число(Сред(ОписаниеНовогоШага, ПозицияРазделителя + 1));
							КонецЕсли;
						КонецЕсли;
						
						НачалоСтроки = "ПрибавкаНаШагеПрогресса=";
						Если СтрНачинаетсяС(СообщениеПользователю.Текст, НачалоСтроки) Тогда
							ПрибавкаНаШагеПрогресса = Число(Сред(СообщениеПользователю.Текст, СтрДлина(НачалоСтроки) + 1));
						КонецЕсли;
					КонецЦикла;
					// Продвигаем индикатор прогресса.
					НовыйПрогрессВыполнения = НачалоШагаПрогресса + ПрибавкаНаШагеПрогресса/100*ДлинаШагаПрогресса;
					Если ПрогрессВыполнения < НовыйПрогрессВыполнения Тогда
						ПрогрессВыполнения = НовыйПрогрессВыполнения;
					КонецЕсли;
				КонецЕсли;
			КонецЕсли;
		Исключение
			
			Задание = ФоновыеЗадания.НайтиПоУникальномуИдентификатору(ФоновоеЗаданиеИдентификатор);
			Если Задание <> Неопределено Тогда
				ВсеСообщения = Задание.ПолучитьСообщенияПользователю(Истина);
				Если ВсеСообщения <> Неопределено Тогда
					Для Каждого СообщениеПользователю Из ВсеСообщения Цикл
						
						НачалоСтроки = "ОбменДанными=";
						Если СтрНачинаетсяС(СообщениеПользователю.Текст, НачалоСтроки) Тогда
							ИмяПланаОбмена = Сред(СообщениеПользователю.Текст, СтрДлина(НачалоСтроки) + 1);
						КонецЕсли;
						
					КонецЦикла;
					
				КонецЕсли;
				
			КонецЕсли;
			
			ИнформацияОбОшибке = ИнформацияОбОшибке();
		КонецПопытки;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьПараметрыСеансаИзФоновогоЗадания()
	РезультатОбновления = ПолучитьИзВременногоХранилища(ФоновоеЗаданиеАдресХранилища);
	ПараметрыСеанса.ПараметрыКлиентаНаСервере = РезультатОбновления.ПараметрыКлиентаНаСервере;
КонецПроцедуры

#КонецОбласти
