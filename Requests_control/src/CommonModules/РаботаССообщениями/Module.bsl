////////////////////////////////////////////////////////////////////////////////
// Модуль для работы с сообщениями.
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Возвращает имя учетной записи для рассылки сообщений.
//
// Возвращаемое значение:
//  Строка - Имя учетной записи для рассылки сообщений.
//
Функция ИмяУчетнойЗаписиДляРассылкиСообщений() Экспорт
	
	Возврат НСтр("ru = '1С:УчетОбращений'");
	
КонецФункции

// Обработчик регламентного задания РассылкаСообщений.
// Выполняет рассылку сообщений по почте.
//
Процедура РассылкаСообщений() Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	ОбщегоНазначения.ПриНачалеВыполненияРегламентногоЗадания(Метаданные.РегламентныеЗадания.РассылкаСообщений);
	
	Если Не ВозможноВыполнитьРассылкуСообщений() Тогда
		Возврат;
	КонецЕсли;
	
	Соединение = Неопределено;
	Для Каждого Сообщение Из СообщенияДляРассылки() Цикл
		ОтправитьСообщенияПоПочте(Сообщение, Соединение);
	КонецЦикла;
	
	ЗакрытьСоединениеСПочтовымСервером(Соединение);
	
КонецПроцедуры

// Выполняет запуск фонового задания рассылки сообщений.
//
Процедура ЗапуститьРассылкуСообщений() Экспорт
	
	ОбщегоНазначения.ПриНачалеВыполненияРегламентногоЗадания();
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если Не НастроенаРассылкаСообщений() Тогда
		Возврат;
	КонецЕсли;
	
	Попытка
		РегламентныеЗаданияСлужебный.ВыполнитьРегламентноеЗаданиеВручную(
			Метаданные.РегламентныеЗадания.РассылкаСообщений);
	Исключение
		ТекстОшибки = СтрШаблон(НСтр("ru = 'Ошибка при запуске рассылки сообщений: %1'",
				ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()),
			ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		ЗаписьЖурналаРегистрации(
			СобытиеЖурналаРегистрации(),
			УровеньЖурналаРегистрации.Ошибка,,,
			ТекстОшибки);
		Возврат;
	КонецПопытки;
	
КонецПроцедуры

// Выполняет запуск фонового задания формирования сообщений.
//
Процедура ЗапуститьФормированиеСообщений() Экспорт
	
	ОбщегоНазначения.ПриНачалеВыполненияРегламентногоЗадания();
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если Не ТребуетсяФормированиеСообщений() Тогда
		Возврат;
	КонецЕсли;
	
	Попытка
		РегламентныеЗаданияСлужебный.ВыполнитьРегламентноеЗаданиеВручную(
			Метаданные.РегламентныеЗадания.ФормированиеСообщений);
	Исключение
		ТекстОшибки = СтрШаблон(НСтр("ru = 'Ошибка при запуске формирования сообщений: %1'",
				ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()),
			ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		ЗаписьЖурналаРегистрации(
			СобытиеЖурналаРегистрации(),
			УровеньЖурналаРегистрации.Ошибка,,,
			ТекстОшибки);
		Возврат;
	КонецПопытки;
	
КонецПроцедуры

// Проверяет, требуется ли регистрация схемы e1c.
//
Функция ТребуетсяРегистрацияСхемыE1c() Экспорт
	
	СистемнаяИнформация = Новый СистемнаяИнформация;
	
	Если ЗначениеЗаполнено(СистемнаяИнформация.ИнформацияПрограммыПросмотра) Тогда
		// Приложение является веб-клиентом.
		ОбновитьНавигационнуюСсылкуИнформационнойБазы();
		Возврат Ложь;
	КонецЕсли;
	
	Если СистемнаяИнформация.ТипПлатформы <> ТипПлатформы.Windows_x86
		И СистемнаяИнформация.ТипПлатформы <> ТипПлатформы.Windows_x86_64 Тогда
		Возврат Ложь;
	КонецЕсли;
	
	ОбновитьНавигационнуюСсылкуИнформационнойБазы();
	
	ТекущийПользователь = ПользователиКлиентСервер.ТекущийПользователь();
	ИдентификаторКлиента = СистемнаяИнформация.ИдентификаторКлиента;
	КаталогПрограммы = КаталогПрограммы();
	
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ПользователиКлиенты.Ссылка
		|ИЗ
		|	Справочник.Пользователи.Клиенты КАК ПользователиКлиенты
		|ГДЕ
		|	ПользователиКлиенты.Ссылка = &Ссылка
		|	И ПользователиКлиенты.ИдентификаторКлиента = &ИдентификаторКлиента
		|	И ПользователиКлиенты.КаталогПрограммы ПОДОБНО &КаталогПрограммы";
	
	Запрос.УстановитьПараметр("Ссылка", ТекущийПользователь);
	Запрос.УстановитьПараметр("ИдентификаторКлиента", ИдентификаторКлиента);
	Запрос.УстановитьПараметр("КаталогПрограммы", КаталогПрограммы);
	
	Результат = Запрос.Выполнить();
	
	Возврат Результат.Пустой();
	
КонецФункции

// Обработчик регламентного задания ФормированиеСообщений.
// Выполняет формирование сообщений по различным событиям в программе.
//
Процедура ФормированиеСообщений() Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	ОбщегоНазначения.ПриНачалеВыполненияРегламентногоЗадания(Метаданные.РегламентныеЗадания.ФормированиеСообщений);
	
	Если Не ТребуетсяФормированиеСообщений() Тогда
		Возврат;
	КонецЕсли;
	Константы.ДатаФормированияСообщений.Установить(ТекущаяДатаСеанса());
	
	КонтрольСрокаРассмотренияОбращения();
	
	ПроверитьНаличиеОбновления();
	
КонецПроцедуры

// Проверяет необходимость формирования сообщений.
//
// Возвращаемое значение:
//  Булево - Требуется выполнить формирование сообщений.
//
Функция ТребуетсяФормированиеСообщений() Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Возврат НачалоДня(ТекущаяДатаСеанса()) > Константы.ДатаФормированияСообщений.Получить();
	
КонецФункции

// Добалвяет сообщение о назначении ответственным за обращение.
//
Процедура ДобавитьСообщениеОНазначенииОтветственным(Кому, Предмет) Экспорт
	
	Текст = СтрШаблон(НСтр("ru = 'Вы назначены ответственным за ""%1""'"), Предмет);
	ДобавитьСообщение(Кому, Текст, Предмет);
	
КонецПроцедуры

// Выполняет обновление использования создания сообщений.
Функция ОбновитьИспользованиеСозданияСообщений() Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	ИзмененоЗначениеИспользования = Ложь;
	
	Запрос = Новый Запрос(
		"ВЫБРАТЬ ПЕРВЫЕ 2
		|	Пользователи.Ссылка КАК Ссылка
		|ИЗ
		|	Справочник.Пользователи КАК Пользователи
		|ГДЕ
		|	Пользователи.Служебный = ЛОЖЬ
		|	И Пользователи.Недействителен = ЛОЖЬ
		|	И Пользователи.ПометкаУдаления = ЛОЖЬ");
	Выборка = Запрос.Выполнить().Выбрать();
	АктуальноеИспользоватьСозданиеСообщений = Выборка.Количество() >= 2;
	
	ТекущееИспользоватьСозданиеСообщений = Константы.ИспользоватьСозданиеСообщений.Получить();
	Если АктуальноеИспользоватьСозданиеСообщений <> ТекущееИспользоватьСозданиеСообщений Тогда
		Константы.ИспользоватьСозданиеСообщений.Установить(АктуальноеИспользоватьСозданиеСообщений);
		ИзмененоЗначениеИспользования = Истина;
	КонецЕсли;
	
	Возврат ИзмененоЗначениеИспользования;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Проверяет, возможно ли выполнить рассылку сообщений.
// Если системная учетная запись электронной почты заблокирована, рассылку сообщений выполнить невозможно.
//
// Параметры:
//  ИмяПараметра - Список типов - Текстовое описание параметра функции.
//   * ИмяСвойстваПараметра - Список типов - Текстовое описание свойства (колонки) параметра.
//
// Возвращаемое значение:
//  Тип - Текстовое описание содержания возвращаемого значения функции.
//
Функция ВозможноВыполнитьРассылкуСообщений()
	
	Попытка
		ЗаблокироватьДанныеДляРедактирования(УчетнаяЗаписьДляРассылкиСообщений());
	Исключение
		ТекстОшибки = СтрШаблон(НСтр("ru = 'Не возможно выполнить рассылку сообщений.
				|Возможно рассылка сообщений уже выполняется, либо выполняется настройка рассылки сообщений:
				|%1'",
				ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()),
			ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		ЗаписьЖурналаРегистрации(
			СобытиеЖурналаРегистрации(),
			УровеньЖурналаРегистрации.Информация,,,
			ТекстОшибки);
		Возврат Ложь;
	КонецПопытки;
	
	Возврат Истина;
	
КонецФункции

// Производит отключение от почтового сервера, если соединение с почтовым сервером открыто.
//
// Параметры:
//  Соединение - ИнтернетПочта - Соединение с почтовым сервером.
//
Процедура ЗакрытьСоединениеСПочтовымСервером(Соединение)
	
	Если Соединение = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Попытка
		Соединение.Отключиться();
	Исключение
		ТекстОшибки = СтрШаблон(
				НСтр("ru = 'Ошибка при закрытии соединения с почтовым сервером: %1'",
					ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()),
				ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		ЗаписьЖурналаРегистрации(
			СобытиеЖурналаРегистрации(),
			УровеньЖурналаРегистрации.Ошибка,,,
			ТекстОшибки);
	КонецПопытки;
	Соединение = Неопределено;
	
КонецПроцедуры

// Проверяет, настроена ли рассылка сообщений.
//
// Возвращаемое значение:
//  Булево - Текстовое описание содержания возвращаемого значения функции.
//
Функция НастроенаРассылкаСообщений()
	
	УчетнаяЗаписьДляРассылкиСообщений = УчетнаяЗаписьДляРассылкиСообщений();
	Возврат ЗначениеЗаполнено(УчетнаяЗаписьДляРассылкиСообщений.АдресЭлектроннойПочты);
	
КонецФункции

// Выполняет обновление навигационной ссылки информационной базы пользователя.
//
Процедура ОбновитьНавигационнуюСсылкуИнформационнойБазы()
	
	УстановитьПривилегированныйРежим(Истина);
	
	СсылкаИБ = ПолучитьНавигационнуюСсылкуИнформационнойБазы();
	Если Не ЗначениеЗаполнено(СсылкаИБ) Тогда
		Возврат;
	КонецЕсли;
	
	ТекущийПользователь = ПользователиКлиентСервер.ТекущийПользователь();
	СсылкаИБПользователя = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(
		ТекущийПользователь, "НавигационнаяСсылкаИнформационнойБазы");
	Если СсылкаИБ <> СсылкаИБПользователя Тогда
		ТекущийПользовательОбъект = ТекущийПользователь.ПолучитьОбъект();
		ТекущийПользовательОбъект.НавигационнаяСсылкаИнформационнойБазы = СсылкаИБ;
		ТекущийПользовательОбъект.Записать();
	КонецЕсли;
	
КонецПроцедуры

// Выполняет отправку сообщения по почте.
//
// Параметры:
//  Сообщение - СтрокаТаблицыЗначений - Сообщение для отправки по почте.
//   * Ссылка - СправочникСсылка.Сообщения - Ссылка на отправляемое сообщение.
//   * Дата - Дата - Дата отправки сообщения.
//   * Текст - Список типов - Текст сообщения.
//   * Автор - СправочникСсылка.Пользователи - От кого отправлено сообщение.
//   * Предмет - СправочникСсылка - Ссылка на предмет сообщения.
//   * ПредставлениеПредмета - Строка - Представление предмета сообщения.
//   * EMail - Список типов - Адрес, на который будет выполнена отправка сообщения.
//   * НавигационнаяСсылкаИнформационнойБазы - Строка - Навигационная ссылка на базу, для пользователя.
//   * ПредставлениеАвтора - Строка - Представление автора сообщения.
//  Соединение - ИнтернетПочта - существующее соединение с почтовым сервером для рассылки сообщений.
//                               Если не указано, то соединение устанавливается отдельно для каждого сообщения.
//
Процедура ОтправитьСообщенияПоПочте(Сообщение, Соединение)
	
	Попытка
		
		ЗаблокироватьДанныеДляРедактирования(Сообщение.Ссылка);
		
		СообщениеОбъект = Сообщение.Ссылка.ПолучитьОбъект();
		Если Не РаботаССообщениямиКлиентСервер.ТребуетсяОтправитьСообщение(СообщениеОбъект) Тогда
			РазблокироватьДанныеДляРедактирования(Сообщение.Ссылка);
			Возврат;
		КонецЕсли;
		
		Если Не НастроенаРассылкаСообщений() Или Не ЗначениеЗаполнено(Сообщение.EMail) Тогда
			СообщениеОбъект.ДатаОтправкиПоПочте = Дата(1,1,2);
			СообщениеОбъект.Записать();
			РазблокироватьДанныеДляРедактирования(Сообщение.Ссылка);
			Возврат;
		КонецЕсли;
		
		ПараметрыПисьма = Новый Структура;
		ПараметрыПисьма.Вставить("Кому", Сообщение.EMail);
		ПараметрыПисьма.Вставить("Тема", ТемаПисьма(Сообщение));
		ПараметрыПисьма.Вставить("Тело", ТелоПисьма(Сообщение));
		ПараметрыПисьма.Вставить("ОбрабатыватьТексты", Ложь);
		ПараметрыПисьма.Вставить("ТипТекста", Перечисления.ТипыТекстовЭлектронныхПисем.HTML);
		
		Если Соединение = Неопределено Тогда
			Соединение = СоединениеСПочтовымСервером();
		КонецЕсли;
		РаботаСПочтовымиСообщениями.ОтправитьПочтовоеСообщение(
			УчетнаяЗаписьДляРассылкиСообщений(),
			ПараметрыПисьма,
			Соединение);
		
		СообщениеОбъект.ДатаОтправкиПоПочте = ТекущаяДатаСеанса();
		СообщениеОбъект.Записать();
		РазблокироватьДанныеДляРедактирования(Сообщение.Ссылка);
		
	Исключение
		ТекстОшибки = СтрШаблон(НСтр("ru = 'Ошибка при рассылке сообщений: %1'",
				ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()),
			ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		ЗаписьЖурналаРегистрации(
			СобытиеЖурналаРегистрации(),
			УровеньЖурналаРегистрации.Ошибка,,,
			ТекстОшибки);
		ЗакрытьСоединениеСПочтовымСервером(Соединение);
		Возврат;
	КонецПопытки;
	
КонецПроцедуры

// Возвращает событие журнала регистрации.
//
Функция СобытиеЖурналаРегистрации()
	
	СобытиеЖурналаРегистрации = НСтр("ru = 'Рассылка сообщений'",
		ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка());
	
	Возврат СобытиеЖурналаРегистрации;
	
КонецФункции

// Возвращает соединение с почтовым сервером для рассылки сообщений.
//
// Возвращаемое значение:
//  ИнтернетПочта - Соединение с почтовым сервером для рассылки сообщений.
//
Функция СоединениеСПочтовымСервером()
	
	Если Не НастроенаРассылкаСообщений() Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Попытка
		Профиль = РаботаСПочтовымиСообщениямиСлужебный.ИнтернетПочтовыйПрофиль(
			УчетнаяЗаписьДляРассылкиСообщений());
		Соединение = Новый ИнтернетПочта;
		Соединение.Подключиться(Профиль);
	Исключение
		ТекстОшибки = СтрШаблон(
				НСтр("ru = 'Ошибка при установке соединения с почтовым сервером: %1'",
					ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()),
				ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		ЗаписьЖурналаРегистрации(
			СобытиеЖурналаРегистрации(),
			УровеньЖурналаРегистрации.Ошибка,,,
			ТекстОшибки);
		Возврат Неопределено;
	КонецПопытки;
	
	Возврат Соединение;
	
КонецФункции

// Формирует таблицу сообщений для рассылки.
//
// Возвращаемое значение:
//  ТаблицаЗначений - Таблица сообщений для рассылки.
//
Функция СообщенияДляРассылки()
	
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	Сообщения.Ссылка КАК Ссылка,
		|	Сообщения.Дата КАК Дата,
		|	Сообщения.Текст КАК Текст,
		|	Сообщения.Автор КАК Автор,
		|	Сообщения.Предмет КАК Предмет,
		|	ПРЕДСТАВЛЕНИЕССЫЛКИ(Сообщения.Предмет) КАК ПредставлениеПредмета,
		|	ПользователиКому.АдресЭлектроннойПочты КАК EMail,
		|	ПользователиКому.НавигационнаяСсылкаИнформационнойБазы КАК НавигационнаяСсылкаИнформационнойБазы,
		|	ПользователиАвтор.Представление КАК ПредставлениеАвтора
		|ИЗ
		|	Справочник.Сообщения КАК Сообщения
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Пользователи КАК ПользователиКому
		|		ПО Сообщения.Кому = ПользователиКому.Ссылка
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Пользователи КАК ПользователиАвтор
		|		ПО Сообщения.Автор = ПользователиАвтор.Ссылка
		|ГДЕ
		|	Сообщения.ДатаОтправкиПоПочте = ДАТАВРЕМЯ(1, 1, 1)";
	
	Возврат Запрос.Выполнить().Выгрузить();
	
КонецФункции

// Формирует тело письма по сообщению.
//
// Параметры:
//  Сообщение - СтрокаТаблицыЗначений - Сообщение для отправки по почте.
//   * Ссылка - СправочникСсылка.Сообщения - Ссылка на отправляемое сообщение.
//   * Дата - Дата - Дата отправки сообщения.
//   * Текст - Список типов - Текст сообщения.
//   * Автор - СправочникСсылка.Пользователи - От кого отправлено сообщение.
//   * Предмет - СправочникСсылка - Ссылка на предмет сообщения.
//   * ПредставлениеПредмета - Строка - Представление предмета сообщения.
//   * EMail - Список типов - Адрес, на который будет выполнена отправка сообщения.
//   * НавигационнаяСсылкаИнформационнойБазы - Строка - Навигационная ссылка на базу, для пользователя.
//   * ПредставлениеАвтора - Строка - Представление автора сообщения.
//
// Возвращаемое значение:
//  Строка - Тело письма.
//
Функция ТелоПисьма(Сообщение)
	
	ТелоПисьма = Новый Массив;
	ТелоПисьма.Добавить("<html>
		|<body>");
	
	// Текст сообщения.
	ТекстТелаПисьма = РаботаС_HTML.ЗаменитьСпецСимволыHTML(Сообщение.Текст);
	ПараметрыВыделенияСсылок = РаботаС_HTML.ПараметрыВыделенияСсылок();
	ПараметрыВыделенияСсылок.ПолучатьПредставление = Истина;
	ПараметрыВыделенияСсылок.СохранятьСсылкиПриПолученииПредставления = Истина;
	ПараметрыВыделенияСсылок.КодироватьНавигационныеСсылки = Истина;
	ПараметрыВыделенияСсылок.НавигационнаяСсылкаИнформационнойБазы = Сообщение.НавигационнаяСсылкаИнформационнойБазы;
	ПараметрыВыделенияСсылок.ЗаполнятьСвойствоTitle = Ложь;
	РаботаС_HTML.ДобавитьТегиКСсылкам(ТекстТелаПисьма, ПараметрыВыделенияСсылок);
	ТекстТелаПисьма = СтрЗаменить(ТекстТелаПисьма, Символы.ПС, "<br>");
	ТелоПисьма.Добавить(ТекстТелаПисьма);
	
	// Ссылка.
	Если ЗначениеЗаполнено(Сообщение.НавигационнаяСсылкаИнформационнойБазы) И ЗначениеЗаполнено(Сообщение.Предмет) Тогда
		
		НавигационнаяСсылка = Новый Массив;
		НавигационнаяСсылка.Добавить(Сообщение.НавигационнаяСсылкаИнформационнойБазы);
		НавигационнаяСсылка.Добавить("#");
		НавигационнаяСсылка.Добавить(ПолучитьНавигационнуюСсылку(Сообщение.Предмет));
		НавигационнаяСсылка = СтрСоединить(НавигационнаяСсылка);
		
		ПолнаяНавигационнаяСсылка = СтрШаблон("<b>%2</b>: <a href=%1>%3</a>",
			КодироватьСтроку(НавигационнаяСсылка, СпособКодированияСтроки.URLВКодировкеURL),
			НСтр("ru = 'Ссылка'"),
			НавигационнаяСсылка);
		
		ТелоПисьма.Добавить("<br>");
		ТелоПисьма.Добавить("<br>");
		ТелоПисьма.Добавить(ПолнаяНавигационнаяСсылка);
		
	КонецЕсли;
	
	// Автор, дата
	ОписаниеОтКого = Справочники.Сообщения.ОписаниеОтКого(Сообщение.Автор, Сообщение.Дата);
	ТелоПисьма.Добавить("<br>");
	ТелоПисьма.Добавить("<br>");
	ТелоПисьма.Добавить(ОписаниеОтКого);
	
	ТелоПисьма.Добавить("</body>
		|</html>");
		
	Возврат СтрСоединить(ТелоПисьма, Символы.ПС);
	
КонецФункции

// Формирует тему письма по сообщению.
//
// Параметры:
//  Сообщение - СтрокаТаблицыЗначений - Сообщение для отправки по почте.
//   * Ссылка - СправочникСсылка.Сообщения - Ссылка на отправляемое сообщение.
//   * Дата - Дата - Дата отправки сообщения.
//   * Текст - Список типов - Текст сообщения.
//   * Автор - СправочникСсылка.Пользователи - От кого отправлено сообщение.
//   * Предмет - СправочникСсылка - Ссылка на предмет сообщения.
//   * ПредставлениеПредмета - Строка - Представление предмета сообщения.
//   * EMail - Список типов - Адрес, на который будет выполнена отправка сообщения.
//   * НавигационнаяСсылкаИнформационнойБазы - Строка - Навигационная ссылка на базу, для пользователя.
//   * ПредставлениеАвтора - Строка - Представление автора сообщения.
//
// Возвращаемое значение:
//  Строка - Тема письма.
//
Функция ТемаПисьма(Сообщение)
	
	Тема = Сообщение.Текст;
	Тема = СокрЛ(Тема);
	Тема = СтрПолучитьСтроку(Тема, 1);
	Тема = СокрЛП(Тема);
	Если СтрЗаканчиваетсяНа(Тема, ".") Тогда
		Тема = Лев(Тема, СтрДлина(Тема) - 1);
		Тема = СокрП(Тема);
	КонецЕсли;
	
	Возврат Тема;
	
КонецФункции

// Возвращает учетную запись, используемую для рассылки сообщений.
//
Функция УчетнаяЗаписьДляРассылкиСообщений()
	
	Возврат Справочники.УчетныеЗаписиЭлектроннойПочты.СистемнаяУчетнаяЗаписьЭлектроннойПочты;
	
КонецФункции

// Формирует сообщения, связанные с ответом на обращения.
//
Процедура КонтрольСрокаРассмотренияОбращения()
	
	ТекущаяДата = НачалоДня(ТекущаяДатаСеанса());
	
	КоличествоДнейДоСрока = 3;
	СтрокаКоличествоДнейДоСрока = СтрокаСЧисломКоличествоДней(КоличествоДнейДоСрока);
	
	Запрос = Новый Запрос(
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	Обращения.Ссылка КАК Ссылка,
		|	Обращения.Ответственный КАК Ответственный,
		|	Обращения.СрокРассмотрения КАК СрокРассмотрения,
		|	Обращения.Представление КАК Представление
		|ИЗ
		|	Справочник.Обращения КАК Обращения
		|ГДЕ
		|	Обращения.Отработано = ЛОЖЬ
		|	И (Обращения.СрокРассмотрения МЕЖДУ &ТекущаяДата И &ПредупреждатьПо
		|			ИЛИ Обращения.СрокРассмотрения < &ТекущаяДата
		|				И Обращения.СрокРассмотрения <> ДАТАВРЕМЯ(1, 1, 1))
		|	И Обращения.ПометкаУдаления = ЛОЖЬ
		|ИТОГИ ПО
		|	Ответственный");
	Запрос.УстановитьПараметр("ТекущаяДата", ТекущаяДата);
	ПредупреждатьПо = ТекущаяДата + 86400 * КоличествоДнейДоСрока; // 86400 - число секунд в дне.
	Запрос.УстановитьПараметр("ПредупреждатьПо", ПредупреждатьПо);
	
	СтрокиСообщения = Новый Массив;
	СтрокиСписокОбращений = Новый Массив;
	ОбращенияПросроченные = Новый Массив;
	ОбращенияСрокСегодня = Новый Массив;
	ОбращенияСрокСкоро = Новый Массив;
	ВыборкаОтветственные = Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	Пока ВыборкаОтветственные.Следующий() Цикл
		
		СтрокиСообщения.Очистить();
		ОбращенияПросроченные.Очистить();
		ОбращенияСрокСегодня.Очистить();
		ОбращенияСрокСкоро.Очистить();
		ВыборкаОбращения = ВыборкаОтветственные.Выбрать();
		Пока ВыборкаОбращения.Следующий() Цикл
			ДанныеОбращения = Новый Структура("Ссылка, Ответственный, СрокРассмотрения, Представление");
			ЗаполнитьЗначенияСвойств(ДанныеОбращения, ВыборкаОбращения);
			Если ДанныеОбращения.СрокРассмотрения > ТекущаяДата Тогда
				ОбращенияСрокСкоро.Добавить(ДанныеОбращения);
			ИначеЕсли ДанныеОбращения.СрокРассмотрения = ТекущаяДата Тогда
				ОбращенияСрокСегодня.Добавить(ДанныеОбращения);
			ИначеЕсли ДанныеОбращения.СрокРассмотрения < ТекущаяДата Тогда
				ОбращенияПросроченные.Добавить(ДанныеОбращения);
			КонецЕсли;
		КонецЦикла;
		КоличествоПросроченные = ОбращенияПросроченные.Количество();
		КоличествоСрокСегодня = ОбращенияСрокСегодня.Количество();
		КоличествоСрокСкоро = ОбращенияСрокСкоро.Количество();
		КоличествоИстекаетСрок = КоличествоСрокСегодня + КоличествоСрокСкоро;
		
		Если КоличествоПросроченные = 0 И КоличествоИстекаетСрок = 0 Тогда
			Продолжить;
		КонецЕсли;
		
		ВыводитьСписокОбращений = Истина;
		ПредметСообщения = Неопределено;
		Если КоличествоПросроченные > 0 И КоличествоИстекаетСрок > 0 Тогда
			СтрокаПросроченные = СтрокаСЧисломКоличествоОбращений(КоличествоПросроченные);
			СтрокаИстекаетСрок = СтрокаСЧисломКоличествоОбращений(КоличествоИстекаетСрок);
			ТемаСообщения = СтрШаблон(
				НСтр("ru = 'Просрочено рассмотрение %1, истекает срок рассмотрения %2'"),
				СтрокаПросроченные,
				СтрокаИстекаетСрок);
			
		ИначеЕсли КоличествоПросроченные > 1 И КоличествоИстекаетСрок = 0 Тогда
			СтрокаПросроченные = СтрокаСЧисломКоличествоОбращений(КоличествоПросроченные);
			ТемаСообщения = СтрШаблон(
				НСтр("ru = 'Просрочено рассмотрение %1'"),
				СтрокаПросроченные);
			
		ИначеЕсли КоличествоПросроченные = 1 И КоличествоИстекаетСрок = 0 Тогда
			ДанныеОбращения = ОбращенияПросроченные[0];
			ВыводитьСписокОбращений = Ложь;
			ПредметСообщения = ДанныеОбращения.Ссылка;
			ТемаСообщения = СтрШаблон(
				НСтр("ru = 'Просрочено рассмотрение ""%1""'"),
				ДанныеОбращения.Представление);
			
		ИначеЕсли КоличествоПросроченные = 0 И КоличествоИстекаетСрок > 1 Тогда
			СтрокаИстекаетСрок = СтрокаСЧисломКоличествоОбращений(КоличествоИстекаетСрок);
			ТемаСообщения = СтрШаблон(
				НСтр("ru = 'Истекает срок рассмотрения %1'"),
				СтрокаИстекаетСрок);
			
		ИначеЕсли КоличествоПросроченные = 0 И КоличествоИстекаетСрок = 1 Тогда
			Если КоличествоСрокСегодня = 1 Тогда
				ДанныеОбращения = ОбращенияСрокСегодня[0];
			ИначеЕсли КоличествоСрокСкоро = 1 Тогда
				ДанныеОбращения = ОбращенияСрокСкоро[0];
			КонецЕсли;
			ВыводитьСписокОбращений = Ложь;
			ПредметСообщения = ДанныеОбращения.Ссылка;
			ТемаСообщения = СтрШаблон(
				НСтр("ru = '%1 истекает срок рассмотрения ""%2""'"),
				ПредставлениеСрока(ДанныеОбращения.СрокРассмотрения),
				ДанныеОбращения.Представление);
			
		КонецЕсли;
		СтрокиСообщения.Добавить(ТемаСообщения);
		
		Если ВыводитьСписокОбращений Тогда
			
			Если КоличествоПросроченные > 0 Тогда
				
				СтрокиСписокОбращений.Очистить();
				ЗаголовокСписка = НСтр("ru = 'Просрочено рассмотрение'");
				СтрокиСписокОбращений.Добавить(ЗаголовокСписка + ":");
				
				Для Каждого ДанныеОбращения Из ОбращенияПросроченные Цикл
					НавигационнаяСсылка = ПолучитьНавигационнуюСсылку(ДанныеОбращения.Ссылка);
					СтрокиСписокОбращений.Добавить("- " + НавигационнаяСсылка);
				КонецЦикла;
				
				СписокОбращенийПросрочено = СтрСоединить(СтрокиСписокОбращений, Символы.ПС);
				СтрокиСообщения.Добавить(СписокОбращенийПросрочено);
				
			КонецЕсли;
			
			Если КоличествоСрокСегодня > 0 Тогда
				
				СтрокиСписокОбращений.Очистить();
				ЗаголовокСписка = НСтр("ru = 'Срок рассмотрения истекает сегодня'");
				СтрокиСписокОбращений.Добавить(ЗаголовокСписка + ":");
				
				Для Каждого ДанныеОбращения Из ОбращенияСрокСегодня Цикл
					НавигационнаяСсылка = ПолучитьНавигационнуюСсылку(ДанныеОбращения.Ссылка);
					СтрокиСписокОбращений.Добавить("- " + НавигационнаяСсылка);
				КонецЦикла;
				
				СписокСрокСегодня = СтрСоединить(СтрокиСписокОбращений, Символы.ПС);
				СтрокиСообщения.Добавить(СписокСрокСегодня);
				
			КонецЕсли;
			
			Если КоличествоСрокСкоро > 0 Тогда
				
				СтрокиСписокОбращений.Очистить();
				ЗаголовокСписка = СтрШаблон(
					НСтр("ru = 'Срок рассмотрения истекает через %1'"),
					СтрокаКоличествоДнейДоСрока);
				СтрокиСписокОбращений.Добавить(ЗаголовокСписка + ":");
				
				Для Каждого ДанныеОбращения Из ОбращенияСрокСкоро Цикл
					НавигационнаяСсылка = ПолучитьНавигационнуюСсылку(ДанныеОбращения.Ссылка);
					СтрокиСписокОбращений.Добавить("- " + НавигационнаяСсылка);
				КонецЦикла;
				
				СписокСрокСкоро = СтрСоединить(СтрокиСписокОбращений, Символы.ПС);
				СтрокиСообщения.Добавить(СписокСрокСкоро);
				
			КонецЕсли;
			
		КонецЕсли;
		
		ТекстСообщения = СтрСоединить(СтрокиСообщения, Символы.ПС + Символы.ПС);
		
		ДобавитьСообщениеБезопасно(ВыборкаОтветственные.Ответственный, ТекстСообщения, ПредметСообщения);
		
	КонецЦикла;
	
КонецПроцедуры

// Формирует строку с числом количества обращений.
Функция СтрокаСЧисломКоличествоОбращений(КоличествоОбращений) Экспорт
	
	СтрокиКоличество = Новый Массив;
	СтрокиКоличество.Добавить("%1 " + НСтр("ru = 'обращений'")); // Ноль
	СтрокиКоличество.Добавить("%1 " + НСтр("ru = 'обращения'")); // Один
	СтрокиКоличество.Добавить("%1 " + НСтр("ru = 'обращений'")); // Два
	СтрокиКоличество.Добавить("%1 " + НСтр("ru = 'обращений'")); // Немного
	СтрокиКоличество.Добавить("%1 " + НСтр("ru = 'обращений'")); // Много
	СтрокиКоличество.Добавить("%1 " + НСтр("ru = 'обращений'")); // Другое
	ИсходнаяСтрокаКоличество = СтрСоединить(СтрокиКоличество, ";");
	
	СтрокаСЧисломКоличествоОбращений = СтрокаСЧислом(
		ИсходнаяСтрокаКоличество,
		КоличествоОбращений,
		ВидЧисловогоЗначения.Количественное);
	
	Возврат СтрокаСЧисломКоличествоОбращений;
	
КонецФункции

// Формирует строку с числом количества обращений.
Функция СтрокаСЧисломКоличествоДней(КоличествоДней) Экспорт
	
	СтрокиКоличество = Новый Массив;
	СтрокиКоличество.Добавить("%1 " + НСтр("ru = 'дня'")); // Ноль
	СтрокиКоличество.Добавить("%1 " + НСтр("ru = 'день'")); // Один
	СтрокиКоличество.Добавить("%1 " + НСтр("ru = 'дня'")); // Два
	СтрокиКоличество.Добавить("%1 " + НСтр("ru = 'дня'")); // Немного
	СтрокиКоличество.Добавить("%1 " + НСтр("ru = 'дней'")); // Много
	СтрокиКоличество.Добавить("%1 " + НСтр("ru = 'дня'")); // Другое
	ИсходнаяСтрокаКоличество = СтрСоединить(СтрокиКоличество, ";");
	
	СтрокаСЧисломКоличествоОбращений = СтрокаСЧислом(
		ИсходнаяСтрокаКоличество,
		КоличествоДней,
		ВидЧисловогоЗначения.Количественное);
	
	Возврат СтрокаСЧисломКоличествоОбращений;
	
КонецФункции

// Формирует сообщение.
//
// Параметры:
//  Кому - СправочникСсылка.Пользователи - Адресат сообщения.
//  Текст - Строка - Текст сообщения.
//  Предмет - СправочникСсылка.* - Ссылка на предмет сообщения.
//
Процедура ДобавитьСообщение(Кому, Текст, Предмет)
	
	Если Не ЗначениеЗаполнено(Кому) Тогда
		Возврат;
	КонецЕсли;
	
	Автор = Справочники.Пользователи.ПустаяСсылка();
	
	Справочники.Сообщения.Добавить(Автор, Кому, Текст, Предмет);
	
КонецПроцедуры

// Формирует сообщение не вызывая исключения в случае ошибки, записывая его в журнал регистрации.
//
// Параметры:
//  Кому - СправочникСсылка.Пользователи - Адресат сообщения.
//  Текст - Строка - Текст сообщения.
//  Предмет - СправочникСсылка.* - Ссылка на предмет сообщения.
//
Процедура ДобавитьСообщениеБезопасно(Кому, Текст, Предмет)
	
	Попытка
		ДобавитьСообщение(Кому, Текст, Предмет);
	Исключение
		ТекстОшибки = СтрШаблон(НСтр("ru = 'Ошибка при формировании сообщения: %1'",
				ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()),
			ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		ЗаписьЖурналаРегистрации(
			СобытиеЖурналаРегистрации(),
			УровеньЖурналаРегистрации.Ошибка,,,
			ТекстОшибки);
		Возврат;
	КонецПопытки;
	
КонецПроцедуры

// Подпись к количеству дней по склонениям.
//
// Параметры:
//  ЧислоДней - Число - Число дней.
//
// Возвращаемое значение:
//  Строка - Подпись количества дней.
//
Функция ПолучитьПодписьДней(ЧислоДней)
	
	ВариантыНаписания = Новый Массив;
	ВариантыНаписания.Добавить(НСтр("ru = 'день'"));
	ВариантыНаписания.Добавить(НСтр("ru = 'дня'"));
	ВариантыНаписания.Добавить(НСтр("ru = 'дней'"));
	ВариантыНаписания = СтрСоединить(ВариантыНаписания, ",");
	
	Возврат СтроковыеФункцииКлиентСервер.ЧислоЦифрамиПредметИсчисленияПрописью(
		ЧислоДней, ВариантыНаписания, Ложь);
	
КонецФункции

// Формирует текстовое представление срока.
//
// Параметры:
//  Срок - Дата - Срок, представление которого хотим получить.
//
// Возвращаемое значение:
//  Строка - Текстовое представление срока.
//
Функция ПредставлениеСрока(Срок)
	
	ПредставлениеСрока = "";
	
	ОсталосьДней = (НачалоДня(Срок) - НачалоДня(ТекущаяДатаСеанса())) / 86400; // 86400 - число секунд в дне.
	Если ОсталосьДней = 0 Тогда
		ПредставлениеСрока = НСтр("ru = 'Сегодня'");
	ИначеЕсли ОсталосьДней = 1 Тогда
		ПредставлениеСрока = НСтр("ru = 'Завтра'");
	Иначе
		ПредставлениеСрока = СтрШаблон(НСтр("ru = 'Через %1 %2'"),
			ОсталосьДней,
			ПолучитьПодписьДней(ОсталосьДней));
	КонецЕсли;
	
	Возврат ПредставлениеСрока;
	
КонецФункции

// Выполняет проверку наличия обновления через интернет.
//
Процедура ПроверитьНаличиеОбновления()
	
	Попытка
		
		ПараметрыФайлаПроверкиОбновления =
			ОбновлениеКонфигурацииПереопределяемый.ПолучитьФайлПроверкиНаличияОбновлений();
		Если ПараметрыФайлаПроверкиОбновления = Неопределено Тогда
			Возврат;
		КонецЕсли;
		
		ДоступноОбновлениеДляНовойРедакции = Ложь;
		ВерсияКонфигурации = Метаданные.Версия;
		ПоследняяВерсияКонфигурации = ПараметрыФайлаПроверкиОбновления.Version;
		Если ОбщегоНазначенияКлиентСервер.СравнитьВерсии(ВерсияКонфигурации, ПоследняяВерсияКонфигурации) >= 0 Тогда
			Возврат;
		КонецЕсли;
		
		Если Константы.ПоследняяИзвестнаяВерсияКонфигурации.Получить() = ПоследняяВерсияКонфигурации Тогда
			Возврат;
		КонецЕсли;
		
		ТекстСообщения = НСтр("ru = 'Новая версия ""1С:Учет обращений"" %1 доступна для загрузки:
			|%2'");
		ТекстСообщения = СтрШаблон(ТекстСообщения,
			ПоследняяВерсияКонфигурации,
			СсылкаНаНовуюВерсию(ПоследняяВерсияКонфигурации));
		
		НачатьТранзакцию();
		Попытка
			Администраторы = ПользователиУчетОбращений.Администраторы();
			Константы.ПоследняяИзвестнаяВерсияКонфигурации.Установить(ПоследняяВерсияКонфигурации);
			Для Каждого Администратор Из Администраторы Цикл
				ДобавитьСообщение(Администратор, ТекстСообщения, Неопределено);
			КонецЦикла;
			ЗафиксироватьТранзакцию();
		Исключение
			ОтменитьТранзакцию();
			ВызватьИсключение;
		КонецПопытки;
		
	Исключение
		ТекстОшибки = СтрШаблон(НСтр("ru = 'Не удалось проверить наличие обновлений:
			|%1'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()), ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		ЗаписьЖурналаРегистрации(
			СобытиеЖурналаРегистрации(),
			УровеньЖурналаРегистрации.Ошибка,,,
			ТекстОшибки);
		Возврат;
	КонецПопытки;
	
КонецПроцедуры

// Формирует ссылку на новую версию конфигурации.
//
// Параметры:
//  Версия - Строка - Новая версия конфигурации.
//
// Возвращаемое значение:
//  Строка - Ссылка на новую версию конфигурации.
//
Функция СсылкаНаНовуюВерсию(Версия)
	
	СсылкаНаНовуюВерсию = "https://releases.1c.ru/version_files?nick=%1&ver=%2";
	
	// Определение короткого имени
	КороткоеИмя = "";
	ОбновлениеКонфигурацииПереопределяемый.ПриОпределенииКраткогоИмениКонфигурации(КороткоеИмя);
	
	// Определение редакции конфигурации.
	НомерРедакции = "";
	ПодстрокиВерсии = СтрРазделить(Метаданные.Версия, ".");
	Если ПодстрокиВерсии.Количество() > 1 Тогда
		НомерРедакции = ПодстрокиВерсии[0] + ПодстрокиВерсии[1];
	КонецЕсли;
	КороткоеИмя = КороткоеИмя + НомерРедакции;
	
	СсылкаНаНовуюВерсию = СтрШаблон(СсылкаНаНовуюВерсию, КороткоеИмя, Версия);
	
	Возврат СсылкаНаНовуюВерсию;
	
КонецФункции

// Формирует ссылку mailto.
//
// Параметры:
//  Кому - Строка - Получатель письма.
//  ТемаПисьма - Строка - Тема письма.
//  ТекстПисьма - Строка - Текст письма.
// 
// Возвращаемое значение:
//  Тип - Ссылка mailto.
//
Функция СформироватьСсылкуMailto(Кому, ТемаПисьма, ТекстПисьма)
	
	СсылкаMailto = Новый Массив;
	НачатоЗаполнениеПараметров = Ложь;
	
	ПараметрTo = КодироватьСтроку(Кому, СпособКодированияСтроки.КодировкаURL);
	ПараметрSubject = КодироватьСтроку(ТемаПисьма, СпособКодированияСтроки.КодировкаURL);
	ПараметрBody = КодироватьСтроку(ТекстПисьма, СпособКодированияСтроки.КодировкаURL);
	
	СсылкаMailto = СтрШаблон(
		"mailto:%1?subject=%2&body=%3",
		ПараметрTo,
		ПараметрSubject,
		ПараметрBody);
	
	Возврат СсылкаMailto;
	
КонецФункции

#КонецОбласти