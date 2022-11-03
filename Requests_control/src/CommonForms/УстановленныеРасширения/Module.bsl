&НаКлиенте
Перем ТекущийКонтекст;

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ПроверитьДоступностьРазделенныхДанных();
	
	Если Не Пользователи.ЭтоПолноправныйПользователь() Тогда
		ВызватьИсключение НСтр("ru = 'Недостаточно прав доступа. Обратитесь к администратору.'");
	КонецЕсли;
	
	Если Не ПравоДоступа("Администрирование", Метаданные) Тогда
		Элементы.СписокРасширенийБезопасныйРежимФлаг.ТолькоПросмотр = Истина;
	КонецЕсли;
	
	Если СтандартныеПодсистемыСервер.ЭтоБазоваяВерсияКонфигурации() Тогда
		ВызватьИсключение НСтр("ru = 'Расширения недоступны в базовой версии программы.'");
	КонецЕсли;
	
	Если Не ПравоДоступа("АдминистрированиеРасширенийКонфигурации", Метаданные) Тогда
		Элементы.СписокРасширенийОбновить.ТолькоВоВсехДействиях = Ложь;
		Элементы.СписокРасширений.ТолькоПросмотр = Истина;
		Элементы.СписокРасширенийДобавить.Видимость = Ложь;
		Элементы.СписокРасширенийУдалить.Видимость = Ложь;
		Элементы.СписокРасширенийОбновитьИзФайлаНаДиске.Видимость = Ложь;
		Элементы.СписокРасширенийСохранитьКак.Видимость = Ложь;
		Элементы.СписокРасширенийКонтекстноеМенюДобавить.Видимость = Ложь;
		Элементы.СписокРасширенийКонтекстноеМенюУдалить.Видимость = Ложь;
		Элементы.СписокРасширенийКонтекстноеМенюОбновитьИзФайлаНаДиске.Видимость = Ложь;
		Элементы.СписокРасширенийКонтекстноеМенюСохранитьКак.Видимость = Ложь;
	КонецЕсли;
	
	ОбновитьСписок();
	
	УстановленныеРасширенияНедоступны =
		СтандартныеПодсистемыСервер.УстановленныеРасширенияНедоступны();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Обновить(Команда)
	
	ОбновитьСписок();
	
КонецПроцедуры

&НаКлиенте
Процедура СохранитьКак(Команда)
	
	ТекущееРасширение = Элементы.СписокРасширений.ТекущиеДанные;
	
	Если ТекущееРасширение = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Адрес = СохранитьНаСервере(ТекущееРасширение.ИдентификаторРасширения);
	
	Если Адрес = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Контекст = Новый Структура;
	Контекст.Вставить("Адрес", Адрес);
	Контекст.Вставить("НачальноеИмяФайла", ТекущееРасширение.Имя
		+ "_" + ТекущееРасширение.Версия + ".cfe");
	
	ОбщегоНазначенияКлиент.ПоказатьВопросОбУстановкеРасширенияРаботыСФайлами(
		Новый ОписаниеОповещения("СохранитьКакПослеУстановкиРасширения", ЭтотОбъект, Контекст));
	
КонецПроцедуры

&НаКлиенте
Процедура СохранитьКакПослеУстановкиРасширения(РасширениеПодключено, Контекст) Экспорт
	
	Если РасширениеПодключено Тогда
		ПолучаемыеФайлы = Новый Массив;
		ПолучаемыеФайлы.Добавить(Новый ОписаниеПередаваемогоФайла(
			Контекст.НачальноеИмяФайла, Контекст.Адрес));
		
		Диалог = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Сохранение);
		Диалог.Заголовок = НСтр("ru = 'Выберите файл для сохранения расширения конфигурации'");
		Диалог.Фильтр    = НСтр("ru = 'Файлы расширений конфигурации (*.cfe)|*.cfe|Все файлы (*.*)|*.*'");
		Диалог.МножественныйВыбор = Ложь;
		
		НачатьПолучениеФайлов(Новый ОписаниеОповещения("СохранитьКакПослеПолученияФайлов", ЭтотОбъект, Контекст),
			ПолучаемыеФайлы, Диалог);
	Иначе
		ПолучитьФайл(Контекст.Адрес, Контекст.НачальноеИмяФайла);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СохранитьКакПослеПолученияФайлов(ПолученныеФайлы, Контекст) Экспорт
	
	Возврат;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьИзФайлаНаДиске(Команда)
	
	ТекущееРасширение = Элементы.СписокРасширений.ТекущиеДанные;
	
	Если ТекущееРасширение = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ЗагрузитьРасширение(ТекущееРасширение.ИдентификаторРасширения);
	
КонецПроцедуры

&НаКлиенте
Процедура ПерезапуститьПрограмму(Команда)
	ЗавершитьРаботуСистемы(Ложь, Истина);
КонецПроцедуры

&НаКлиенте
Процедура УдалитьУстаревшиеКэшиРасширений(Команда)
	
	УдалитьУстаревшиеКэшиРасширенийНаСервере();
	
	ПоказатьПредупреждение(, НСтр("ru = 'Выполнено удаление устаревших версий параметров работы расширений.'"));
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписокРасширений

&НаКлиенте
Процедура СписокРасширенийПриАктивизацииСтроки(Элемент)
	
	Если Элементы.СписокРасширений.ТекущиеДанные <> Неопределено Тогда
		ИдентификаторТекущейСтроки = Элементы.СписокРасширений.ТекущаяСтрока;
	Иначе
		ИдентификаторТекущейСтроки = Неопределено;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокРасширенийПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	Отказ = Истина;
	ЗагрузитьРасширение(Неопределено, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокРасширенийПередУдалением(Элемент, Отказ)
	
	Отказ = Истина;
	УдалитьРасширения(Элемент.ВыделенныеСтроки);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокРасширенийПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	
	ТекущееРасширение = Элементы.СписокРасширений.ТекущиеДанные;
	Если ТекущееРасширение = Неопределено Тогда
		Возврат;
	КонецЕсли;

	СписокРасширенийПриОкончанииРедактированияНаСервере(ТекущееРасширение.ПолучитьИдентификатор());
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ОбновитьСписок(ПослеДобавления = Ложь)
	
	Если ПослеДобавления Тогда
		ИндексТекущейСтроки = СписокРасширений.Количество();
	Иначе
		ИндексТекущейСтроки = 0;
		Если ИдентификаторТекущейСтроки <> Неопределено Тогда
			Строка = СписокРасширений.НайтиПоИдентификатору(ИдентификаторТекущейСтроки);
			Если Строка <> Неопределено Тогда
				ИндексТекущейСтроки = СписокРасширений.Индекс(Строка);
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	СписокРасширений.Очистить();
	
	УстановитьПривилегированныйРежим(Истина);
	Расширения = РасширенияКонфигурации.Получить(Неопределено);
	УстановитьПривилегированныйРежим(Ложь);
	
	Для Каждого Расширение Из Расширения Цикл 
		
		ЭлементРасширения = СписокРасширений.Добавить();
		ЭлементРасширения.ИдентификаторРасширения = Расширение.УникальныйИдентификатор;
		ЭлементРасширения.Имя                     = Расширение.Имя;
		ЭлементРасширения.Версия                  = Расширение.Версия;
		ЭлементРасширения.КонтрольнаяСумма        = Base64Строка(Расширение.ХешСумма);
		ЭлементРасширения.Синоним                 = Расширение.Синоним;
		ЭлементРасширения.БезопасныйРежим         = Расширение.БезопасныйРежим;
		
		Если ПустаяСтрока(ЭлементРасширения.Синоним) Тогда
			ЭлементРасширения.Синоним = ЭлементРасширения.Имя;
		КонецЕсли;
		
		Если ТипЗнч(Расширение.БезопасныйРежим) = Тип("Булево") Тогда
			ЭлементРасширения.БезопасныйРежимФлаг = Расширение.БезопасныйРежим;
		Иначе
			ЭлементРасширения.БезопасныйРежимФлаг = Истина;
		КонецЕсли;
	КонецЦикла;
	
	Если ИндексТекущейСтроки >= СписокРасширений.Количество() Тогда
		ИндексТекущейСтроки = СписокРасширений.Количество() - 1;
	КонецЕсли;
	Если ИндексТекущейСтроки >= 0 Тогда
		Элементы.СписокРасширений.ТекущаяСтрока = СписокРасширений.Получить(
			ИндексТекущейСтроки).ПолучитьИдентификатор();
	КонецЕсли;
	
	СоставРасширенийИзменен = ПараметрыСеанса.УстановленныеРасширения
		<> СтандартныеПодсистемыСервер.КонтрольныеСуммыРасширений(СписокРасширений);
	
	Если СтандартныеПодсистемыСервер.УстановленныеРасширенияНедоступны() Тогда
		Элементы.ГруппаПредупреждение.Видимость = Ложь;
		Элементы.ГруппаИнформация.Видимость = СоставРасширенийИзменен;
	Иначе
		Элементы.ГруппаПредупреждение.Видимость = СоставРасширенийИзменен;
		Элементы.ГруппаИнформация.Видимость = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция СохранитьНаСервере(ИдентификаторРасширения)
	
	Расширение = НайтиРасширение(ИдентификаторРасширения);
	
	Если Расширение <> Неопределено Тогда
		Возврат ПоместитьВоВременноеХранилище(Расширение.ПолучитьДанные(), ЭтотОбъект.УникальныйИдентификатор);
	КонецЕсли;
	
	Возврат Неопределено;
	
КонецФункции

&НаСервере
Функция НайтиРасширение(ИдентификаторРасширения)
	
	Отбор = Новый Структура;
	Отбор.Вставить("УникальныйИдентификатор", Новый УникальныйИдентификатор(ИдентификаторРасширения));
	Расширения = РасширенияКонфигурации.Получить(Отбор);
	
	Расширение = Неопределено;
	
	Если Расширения.Количество() = 1 Тогда
		Расширение = Расширения[0];
	КонецЕсли;
	
	Возврат Расширение;
	
КонецФункции

&НаСервере
Процедура УдалитьУстаревшиеКэшиРасширенийНаСервере()
	
	УстановитьПривилегированныйРежим(Истина);
	
	Справочники.ВерсииРасширений.УдалитьУстаревшиеВерсииПараметров();
	
КонецПроцедуры

&НаКлиенте
Процедура УдалитьРасширения(ВыделенныеСтроки)

	Если ВыделенныеСтроки.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	Контекст = Новый Структура;
	Контекст.Вставить("ВыделенныеСтроки", ВыделенныеСтроки);
	
	Оповещение = Новый ОписаниеОповещения("УдалитьРасширениеПослеПодтверждения", ЭтотОбъект, Контекст);
	Если ВыделенныеСтроки.Количество() > 1 Тогда
		ТекстВопроса = Нстр("ru = 'Вы уверены, что хотите удалить выделенные расширения?'", "ru");
	Иначе
		ТекстВопроса = Нстр("ru = 'Вы уверены, что хотите удалить расширение?'", "ru");
	КонецЕсли;

	ПоказатьВопрос(Оповещение, ТекстВопроса, РежимДиалогаВопрос.ДаНет);

КонецПроцедуры

&НаКлиенте
Процедура УдалитьРасширениеПослеПодтверждения(Результат, Контекст) Экспорт

	Если Результат = КодВозвратаДиалога.Да Тогда
		
		Запросы = ЗапросНаОтменуРазрешенийИспользованияВнешнегоМодуля(Контекст.ВыделенныеСтроки);
		
		РаботаВБезопасномРежимеКлиент.ПрименитьЗапросыНаИспользованиеВнешнихРесурсов(Запросы,
			ЭтотОбъект, Новый ОписаниеОповещения("УдалитьРасширениеПродолжение", ЭтотОбъект, Контекст));
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура УдалитьРасширениеПродолжение(Результат, Контекст) Экспорт
	
	Если Результат = КодВозвратаДиалога.ОК Тогда
		ПоказатьДлительнуюОперацию();
		ТекущийКонтекст = Контекст;
		ПодключитьОбработчикОжидания("УдалитьРасширениеЗавершение", 0.1, Истина);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура УдалитьРасширениеЗавершение()
	
	Контекст = ТекущийКонтекст;
	
	ПоказатьДлительнуюОперацию();
	Попытка
		УдалитьРасширенияНаСервере(Контекст.ВыделенныеСтроки);
	Исключение
		ИнформацияОбОшибке = ИнформацияОбОшибке();
		СкрытьДлительнуюОперацию();
		ПоказатьПредупреждение(, СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'После удаления, при подготовке оставшихся расширений к работе, произошла ошибка:
			           |%1'"), КраткоеПредставлениеОшибки(ИнформацияОбОшибке)));
		Возврат;
	КонецПопытки;
	СкрытьДлительнуюОперацию();
	
КонецПроцедуры

&НаСервере
Процедура УдалитьРасширенияНаСервере(ВыделенныеСтроки)
	
	ПроверитьДоступностьРазделенныхДанных();
	
	УдаленныеРасширения = Новый Массив;
	
	НачатьТранзакцию();
	Попытка
		Для Каждого ИдентификаторСтроки Из ВыделенныеСтроки Цикл
			ТекущееРасширение = СписокРасширений.НайтиПоИдентификатору(ИдентификаторСтроки);
			Расширение = НайтиРасширение(ТекущееРасширение.ИдентификаторРасширения);
			Если Расширение <> Неопределено Тогда
				ОписаниеРасширения = Новый Структура;
				ОписаниеРасширения.Вставить("Расширение", Расширение);
				ОписаниеРасширения.Вставить("ДанныеРасширения", Расширение.ПолучитьДанные());
				УдаленныеРасширения.Добавить(ОписаниеРасширения);
			КонецЕсли;
		КонецЦикла;
		Для Каждого ОписаниеРасширения Из УдаленныеРасширения Цикл
			ОписаниеРасширения.Расширение.Удалить();
		КонецЦикла;
		Если РасширенияКонфигурации.Получить().Количество() = 0 Тогда
			Справочники.ВерсииРасширений.ПриУдаленииВсехРасширений();
		КонецЕсли;
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ВызватьИсключение;
	КонецПопытки;
	
	Попытка
		ОбновитьПараметрыРаботыРасширений();
		РасширенияИзменены = Истина;
	Исключение
		ИнформацияОбОшибке = ИнформацияОбОшибке();
		НачатьТранзакцию();
		Попытка
			Для Каждого ОписаниеРасширения Из УдаленныеРасширения Цикл
				ОписаниеРасширения.Расширение.Записать(ОписаниеРасширения.ДанныеРасширения);
			КонецЦикла;
			ЗафиксироватьТранзакцию();
		Исключение
			ОтменитьТранзакцию();
			ТекущаяИнформацияОбОшибке = ИнформацияОбОшибке();
			ВызватьИсключение КраткоеПредставлениеОшибки(ИнформацияОбОшибке) + Символы.ПС + Символы.ПС + СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'При попытке восстановить удаленные расширения произошла еще одна ошибка:
				           |%1'"), КраткоеПредставлениеОшибки(ТекущаяИнформацияОбОшибке));
		КонецПопытки;
		ВызватьИсключение КраткоеПредставлениеОшибки(ИнформацияОбОшибке) + Символы.ПС + Символы.ПС
			+ НСтр("ru = 'Удаленные расширения были восстановлены.'");
	КонецПопытки;
	
	ОбновитьСписок();
	
КонецПроцедуры

&НаСервере
Функция ЗапросНаОтменуРазрешенийИспользованияВнешнегоМодуля(ВыделенныеСтроки)
	
	Разрешения = Новый Массив;
	
	Для Каждого ИдентификаторСтроки Из ВыделенныеСтроки Цикл
		ТекущееРасширение = СписокРасширений.НайтиПоИдентификатору(ИдентификаторСтроки);
		Разрешения.Добавить(РаботаВБезопасномРежиме.РазрешениеНаИспользованиеВнешнегоМодуля(
			ТекущееРасширение.Имя, ТекущееРасширение.КонтрольнаяСумма));
	КонецЦикла;
	
	Запросы = Новый Массив;
	Запросы.Добавить(РаботаВБезопасномРежиме.ЗапросНаОтменуРазрешенийИспользованияВнешнихРесурсов(
		ОбщегоНазначения.ИдентификаторОбъектаМетаданных("РегистрСведений.ПараметрыРаботыВерсийРасширений"),
		Разрешения));
		
	Возврат Запросы;
	
КонецФункции

&НаКлиенте
Процедура ПоказатьДлительнуюОперацию()
	
	Если УстановленныеРасширенияНедоступны Тогда
		Возврат;
	КонецЕсли;
	
	Элементы.СтраницыОбновление.ТекущаяСтраница = Элементы.СтраницаДлительнаяОперация;
	Элементы.СписокРасширенийДобавить.Доступность = Ложь;
	Элементы.СписокРасширенийУдалить.Доступность = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура СкрытьДлительнуюОперацию()
	
	Если УстановленныеРасширенияНедоступны Тогда
		Возврат;
	КонецЕсли;
	
	Элементы.СтраницыОбновление.ТекущаяСтраница = Элементы.СтраницаСписокРасширений;
	Элементы.СписокРасширенийДобавить.Доступность = Истина;
	Элементы.СписокРасширенийУдалить.Доступность = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьРасширение(Знач ИдентификаторРасширения, МножественныйВыбор = Ложь)
	
	Контекст = Новый Структура;
	Контекст.Вставить("ИдентификаторРасширения", ИдентификаторРасширения);
	Контекст.Вставить("МножественныйВыбор", МножественныйВыбор);
	
	ОбщегоНазначенияКлиент.ПоказатьВопросОбУстановкеРасширенияРаботыСФайлами(
		Новый ОписаниеОповещения("ЗагрузитьРасширениеПослеУстановкиРасширения", ЭтотОбъект, Контекст));
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьРасширениеПослеУстановкиРасширения(РасширениеПодключено, Контекст) Экспорт
	
	Если РасширениеПодключено Тогда
		Диалог = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);
		Диалог.Фильтр = НСтр("ru = 'Расширение конфигурации'", "ru")+ " (*.cfe)|*.cfe";
		Диалог.МножественныйВыбор = Контекст.МножественныйВыбор;
		Диалог.ПроверятьСуществованиеФайла = Истина;
		Диалог.Заголовок = НСтр("ru = 'Выберите файл расширения конфигурации'", "ru");
		НачатьПомещениеФайлов(Новый ОписаниеОповещения(
				"ЗагрузитьРасширениеПослеПомещенияФайлов", ЭтотОбъект, Контекст),
			, Диалог, , УникальныйИдентификатор);
	Иначе
		РасширенияФайла = "*.cfe";
		НачатьПомещениеФайла(Новый ОписаниеОповещения(
				"ЗагрузитьРасширениеПослеПомещенияФайла", ЭтотОбъект, Контекст),
			, РасширенияФайла, , ЭтотОбъект.УникальныйИдентификатор);
	КонецЕсли
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьРасширениеПослеПомещенияФайла(ФайлПомещен, Адрес, ВыбранноеИмяФайла, Контекст) Экспорт
	
	Если ФайлПомещен Тогда
		ПомещенныеФайлы = Новый Массив;
		ПомещенныеФайлы.Добавить(Новый ОписаниеПередаваемогоФайла(ВыбранноеИмяФайла, Адрес));
		ЗагрузитьРасширениеПослеПомещенияФайлов(ПомещенныеФайлы, Контекст);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьРасширениеПослеПомещенияФайлов(ПомещенныеФайлы, Контекст) Экспорт
	
	Если ПомещенныеФайлы = Неопределено
	 Или ПомещенныеФайлы.Количество() = 0 Тогда
		
		Возврат;
	КонецЕсли;
	
	Контекст.Вставить("ПомещенныеФайлы", ПомещенныеФайлы);
	
	ЗапросыРазрешений = Новый Массив;
	Попытка
		ДобавитьЗапросРазрешений(ЗапросыРазрешений, ПомещенныеФайлы, Контекст.ИдентификаторРасширения);
	Исключение
		ИнформацияОбОшибке = ИнформацияОбОшибке();
		ПоказатьПредупреждение(, КраткоеПредставлениеОшибки(ИнформацияОбОшибке));
		Возврат;
	КонецПопытки;
	
	ОповещениеОЗакрытии = Новый ОписаниеОповещения(
		"ЗагрузитьРасширениеПродолжение", ЭтотОбъект, Контекст);
	
	РаботаВБезопасномРежимеКлиент.ПрименитьЗапросыНаИспользованиеВнешнихРесурсов(
		ЗапросыРазрешений, ЭтотОбъект, ОповещениеОЗакрытии);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьРасширениеПродолжение(Результат, Контекст) Экспорт
	
	Если Результат <> КодВозвратаДиалога.ОК Тогда
		Возврат;
	КонецЕсли;
	
	ПоказатьДлительнуюОперацию();
	ТекущийКонтекст = Контекст;
	ПодключитьОбработчикОжидания("ЗагрузитьРасширениеЗавершение", 0.1, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьРасширениеЗавершение()
	
	Контекст = ТекущийКонтекст;
	Попытка
		ИзменитьРасширенияНаСервере(Контекст.ПомещенныеФайлы, Контекст.ИдентификаторРасширения);
	Исключение
		ИнформацияОбОшибке = ИнформацияОбОшибке();
		СкрытьДлительнуюОперацию();
		ПоказатьПредупреждение(, СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'После добавления, при подготовке расширений к работе, произошла ошибка:
			           |%1'"), КраткоеПредставлениеОшибки(ИнформацияОбОшибке)));
		Возврат;
	КонецПопытки;
	СкрытьДлительнуюОперацию();
	
	Если Не РасширенияИзменены Тогда
		Возврат;
	КонецЕсли;
	
	Если Контекст.ИдентификаторРасширения = Неопределено Тогда
		Если Контекст.ПомещенныеФайлы.Количество() > 1 Тогда
			ТекстОповещения = НСтр("ru = 'Расширения конфигурации добавлены'", "ru");
		Иначе
			ТекстОповещения = НСтр("ru = 'Расширение конфигурации добавлено'", "ru");
		КонецЕсли;
	Иначе
		ТекстОповещения = НСтр("ru = 'Расширение конфигурации обновлено'", "ru");
	КонецЕсли;
	
	ПоказатьОповещениеПользователя(ТекстОповещения);
	
КонецПроцедуры

&НаСервере
Процедура ИзменитьРасширенияНаСервере(ПомещенныеФайлы, ИдентификаторРасширения = Неопределено)
	
	ПроверитьДоступностьРазделенныхДанных();
	
	РасширенияИзменены = Ложь;
	
	Расширение = Неопределено;

	Если ИдентификаторРасширения <> Неопределено Тогда
		Расширение = НайтиРасширение(ИдентификаторРасширения);
		Если Расширение = Неопределено Тогда
			Возврат;
		КонецЕсли;
		ПрежнееИмяРасширения = Расширение.Имя;
		ДанныеРасширения = Расширение.ПолучитьДанные();
	КонецЕсли;
	
	ДобавленныеРасширения = Новый Массив;
	
	НачатьТранзакцию();
	Попытка
		Если ИдентификаторРасширения <> Неопределено Тогда
			Расширение.Записать(ПолучитьИзВременногоХранилища(ПомещенныеФайлы[0].Хранение));
			Если ПрежнееИмяРасширения <> Расширение.Имя Тогда
				ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Нельзя загрузить расширение ""%1"" в ""%2"".'"),
					Расширение.Имя,
					ПрежнееИмяРасширения);
			КонецЕсли;
		Иначе
			Для Каждого ПомещенныйФайл Из ПомещенныеФайлы Цикл
				Расширение = РасширенияКонфигурации.Создать();
				Расширение.Записать(ПолучитьИзВременногоХранилища(ПомещенныйФайл.Хранение));
				ДобавленныеРасширения.Вставить(0, Расширение);
			КонецЦикла;
		КонецЕсли;
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ВызватьИсключение;
	КонецПопытки;
	
	Попытка
		ОбновитьПараметрыРаботыРасширений();
		РасширенияИзменены = Истина;
	Исключение
		ИнформацияОбОшибке = ИнформацияОбОшибке();
		Если ИдентификаторРасширения <> Неопределено Тогда
			Расширение.Записать(ДанныеРасширения);
		Иначе
			НачатьТранзакцию();
			Попытка
				Для Каждого ДобавленноеРасширение Из ДобавленныеРасширения Цикл
					Отбор = Новый Структура("Имя", ДобавленноеРасширение.Имя);
					Расширения = РасширенияКонфигурации.Получить(Отбор);
					Для Каждого Расширение Из Расширения Цикл
						Если Расширение.ХешСумма = ДобавленноеРасширение.ХешСумма Тогда
							Расширение.Удалить();
						КонецЕсли;
					КонецЦикла;
				КонецЦикла;
				ЗафиксироватьТранзакцию();
			Исключение
				ТекущаяИнформацияОбОшибке = ИнформацияОбОшибке();
				ОтменитьТранзакцию();
				Если ИдентификаторРасширения <> Неопределено Тогда
					ВызватьИсключение КраткоеПредставлениеОшибки(ИнформацияОбОшибке) + Символы.ПС + Символы.ПС + СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
						НСтр("ru = 'При попытке восстановить измененное расширение произошла еще одна ошибка:
						           |%1'"), КраткоеПредставлениеОшибки(ТекущаяИнформацияОбОшибке));
				Иначе
					ВызватьИсключение КраткоеПредставлениеОшибки(ИнформацияОбОшибке) + Символы.ПС + Символы.ПС + СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
						НСтр("ru = 'При попытке удалить добавленные расширения произошла еще одна ошибка:
						           |%1'"), КраткоеПредставлениеОшибки(ТекущаяИнформацияОбОшибке));
				КонецЕсли;
			КонецПопытки;
		КонецЕсли;
		ВызватьИсключение КраткоеПредставлениеОшибки(ИнформацияОбОшибке) + Символы.ПС + Символы.ПС
			+ НСтр("ru = 'Добавленные расширения были удалены.'");
	КонецПопытки;
	
	ОбновитьСписок(ИдентификаторРасширения = Неопределено);
	
КонецПроцедуры

&НаСервере
Процедура СписокРасширенийПриОкончанииРедактированияНаСервере(ИдентификаторРасширения)
	
	НайденноеРасширение = СписокРасширений.НайтиПоИдентификатору(ИдентификаторРасширения);

	Если НайденноеРасширение = Неопределено Тогда
		Возврат;
	КонецЕсли;

	Расширение = НайтиРасширение(НайденноеРасширение.ИдентификаторРасширения);

	Если Расширение <> Неопределено Тогда

		Если ТипЗнч(Расширение.БезопасныйРежим) = Тип("Булево") Тогда
			ПрежнееЗначениеБезопасногоРежима = Расширение.БезопасныйРежим;
		Иначе
			ПрежнееЗначениеБезопасногоРежима = Истина;
		КонецЕсли;

		Если Не НайденноеРасширение.БезопасныйРежимФлаг И НайденноеРасширение.БезопасныйРежимФлаг <> ПрежнееЗначениеБезопасногоРежима Тогда
			Расширение.БезопасныйРежим = НайденноеРасширение.БезопасныйРежим;
		Иначе
			НайденноеРасширение.БезопасныйРежим = Истина;
		КонецЕсли;

		Расширение.Записать();

	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ДобавитьЗапросРазрешений(ЗапросыРазрешений, ПомещенныеФайлы, ИдентификаторРасширения = Неопределено)
	
	Разрешения = Новый Массив;
	
	Для Каждого ПомещенныйФайл Из ПомещенныеФайлы Цикл
		НачатьТранзакцию();
		Попытка
			Если ИдентификаторРасширения = Неопределено Тогда
				ВременноеРасширение = РасширенияКонфигурации.Создать();
			Иначе
				ВременноеРасширение = НайтиРасширение(ИдентификаторРасширения);
			КонецЕсли;
			ВременноеРасширение.Записать(ПолучитьИзВременногоХранилища(ПомещенныйФайл.Хранение));
			ВременноеРасширение.Удалить();
			ОтменитьТранзакцию();
			Разрешения.Добавить(РаботаВБезопасномРежиме.РазрешениеНаИспользованиеВнешнегоМодуля(
				ВременноеРасширение.Имя, Base64Строка(ВременноеРасширение.ХешСумма)));
		Исключение
			ОтменитьТранзакцию();
			ВызватьИсключение;
		КонецПопытки;
	КонецЦикла;
	
	УстановленныеРасширения = РасширенияКонфигурации.Получить();
	Для Каждого Расширение Из УстановленныеРасширения Цикл
		Разрешения.Добавить(РаботаВБезопасномРежиме.РазрешениеНаИспользованиеВнешнегоМодуля(
			Расширение.Имя, Base64Строка(Расширение.ХешСумма)));
	КонецЦикла;
	
	ЗапросыРазрешений.Добавить(РаботаВБезопасномРежиме.ЗапросНаИспользованиеВнешнихРесурсов(Разрешения,
		ОбщегоНазначения.ИдентификаторОбъектаМетаданных("РегистрСведений.ПараметрыРаботыВерсийРасширений")));
	
	Возврат Истина;
	
КонецФункции

&НаСервере
Процедура ОбновитьПараметрыРаботыРасширений()
	
	Если СтандартныеПодсистемыСервер.УстановленныеРасширенияНедоступны() Тогда
		Возврат;
	КонецЕсли;
	
	УстановленныеРасширения = ПараметрыСеанса.УстановленныеРасширения;
	Попытка
		ОчищаемыеПараметры = Новый Массив;
		ОчищаемыеПараметры.Добавить("АдресСвойствРасширений");
		ОчищаемыеПараметры.Добавить("УстановленныеРасширения");
		ПараметрыСеанса.Очистить(ОчищаемыеПараметры);
		ХранилищеСвойствРасширений = Справочники.ИдентификаторыОбъектовМетаданных.ХранилищеСвойствРасширений();
		ПараметрыВыполнения = Новый Структура;
		ПараметрыВыполнения.Вставить("УстановленныеРасширения", ПараметрыСеанса.УстановленныеРасширения);
		ПараметрыВыполнения.Вставить("ХранилищеСвойствРасширений", ХранилищеСвойствРасширений);
		ПараметрыПроцедуры = Новый Массив;
		ПараметрыПроцедуры.Добавить(ПараметрыВыполнения);
		ФоновоеЗадание = ФоновыеЗадания.Выполнить(
			"СтандартныеПодсистемыСервер.ЗаполнитьВсеПараметрыРаботыРасширенийФоновоеЗадание",
			ПараметрыПроцедуры);
		Попытка
			ФоновоеЗадание.ОжидатьЗавершения();
		Исключение
			ИнформацияОбОшибке = ИнформацияОбОшибке();
		КонецПопытки;
		Отбор = Новый Структура("УникальныйИдентификатор", ФоновоеЗадание.УникальныйИдентификатор);
		ФоновоеЗадание = ФоновыеЗадания.ПолучитьФоновыеЗадания(Отбор)[0];
		Если ИнформацияОбОшибке <> Неопределено Тогда
			ИнформацияОбОшибке = ФоновоеЗадание.ИнформацияОбОшибке;
		КонецЕсли;
	Исключение
		ИнформацияОбОшибке = ИнформацияОбОшибке();
	КонецПопытки;
	
	ПараметрыСеанса.УстановленныеРасширения = УстановленныеРасширения;
	ОчищаемыеПараметры = Новый Массив;
	ОчищаемыеПараметры.Добавить("АдресСвойствРасширений");
	ПараметрыСеанса.Очистить(ОчищаемыеПараметры);
	
	Если ИнформацияОбОшибке <> Неопределено Тогда
		ВызватьИсключение ПодробноеПредставлениеОшибки(ИнформацияОбОшибке);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПроверитьДоступностьРазделенныхДанных()
	
	Если Не ОбщегоНазначенияПовтИсп.ДоступноИспользованиеРазделенныхДанных() Тогда
		ВызватьИсключение НСтр("ru = 'Расширения недоступны в неразделенном режиме.'");
	КонецЕсли;
	
КонецПроцедуры


#КонецОбласти
