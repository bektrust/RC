////////////////////////////////////////////////////////////////////////////////
// Подсистема "Обмен данными"
// 
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Определяет префикс кодов и номеров объектов информационной базы по умолчанию.
//
// Параметры:
//	Префикс - Строка, 2 - префикс кодов и номеров объектов информационной базы по умолчанию.
//
Процедура ПриОпределенииПрефиксаИнформационнойБазыПоУмолчанию(Префикс) Экспорт
	
	Префикс = НСтр("ru = ''");
	
КонецПроцедуры

// Определяет список планов обмена, которые используют функционал подсистемы обмена данными.
//
// Параметры:
// ПланыОбменаПодсистемы - Массив - Массив планов обмена конфигурации,
//  которые используют функционал подсистемы обмена данными.
//  Элементами массива являются объекты метаданных планов обмена.
//
// Пример тела процедуры:
//
// ПланыОбменаПодсистемы.Добавить(Метаданные.ПланыОбмена.ОбменБезИспользованияПравилКонвертации);
// ПланыОбменаПодсистемы.Добавить(Метаданные.ПланыОбмена.ОбменСБиблиотекойСтандартныхПодсистем);
// ПланыОбменаПодсистемы.Добавить(Метаданные.ПланыОбмена.РаспределеннаяИнформационнаяБаза);
//
Процедура ПолучитьПланыОбмена(ПланыОбменаПодсистемы) Экспорт
	
	//// _Демо начало примера
	//ПланыОбменаПодсистемы.Добавить(Метаданные.ПланыОбмена._ДемоАвтономнаяРабота);
	//ПланыОбменаПодсистемы.Добавить(Метаданные.ПланыОбмена._ДемоОбменБезИспользованияПравилКонвертации);
	//ПланыОбменаПодсистемы.Добавить(Метаданные.ПланыОбмена._ДемоОбменСБиблиотекойСтандартныхПодсистем);
	//ПланыОбменаПодсистемы.Добавить(Метаданные.ПланыОбмена._ДемоОбменСБиблиотекойСтандартныхПодсистем225);
	//ПланыОбменаПодсистемы.Добавить(Метаданные.ПланыОбмена._ДемоОбменВРаспределеннойИнформационнойБазе);
	//ПланыОбменаПодсистемы.Добавить(Метаданные.ПланыОбмена._ДемоСинхронизацияДанныхЧерезУниверсальныйФормат);
	//// _Демо конец примера
	
КонецПроцедуры

// Обработчик при выгрузке данных.
// Используется для переопределения стандартной обработки выгрузки данных.
// В данном обработчике должна быть реализована логика выгрузки данных:
// выборка данных для выгрузки, сериализация данных в файл сообщения или сериализация данных в поток.
// После выполнения обработчика выгруженные данные будут отправлены получателю подсистемой обмена данными.
// Формат сообщения для выгрузки может быть произвольным.
// В случае ошибок при отправке данных следует прерывать выполнение обработчика
// методом ВызватьИсключение с описанием ошибки.
//
// Параметры:
//
// СтандартнаяОбработка - Булево - В данный параметр передается признак выполнения стандартной (системной) обработки
//                                 события.
//  Если в теле процедуры-обработчика установить данному параметру значение Ложь, стандартная
//  обработка события производиться не будет. Отказ от стандартной обработки не отменяет действие.
//  Значение по умолчанию - Истина.
//
// Получатель - ПланОбменаСсылка - Узел плана обмена, для которого выполняется выгрузка данных.
//
// ИмяФайлаСообщения - Строка - Имя файла, в который необходимо выполнить выгрузку данных.
//  Если этот параметр заполнен, то система ожидает,
//  что данные будут выгружены в файл. После выгрузки система выполнит отправку данных из этого файла.
//  Если параметр пустой, то система ожидает, что данные будут выгружены в параметр ДанныеСообщения.
//
// ДанныеСообщения - Произвольный - Если параметр ИмяФайлаСообщения пустой,
//  то система ожидает, что данные будут выгружены в этот параметр.
//
// КоличествоЭлементовВТранзакции - Число - Определяет максимальное число элементов данных,
//  которые помещаются в сообщение в рамках одной транзакции базы данных.
//  При необходимости в обработчике следует реализовать логику
//  установки транзакционных блокировок на выгружаемые данные.
//  Значение параметра задается в настройках подсистемы обмена данными.
//
// ИмяСобытияЖурналаРегистрации - Строка - Имя события журнала регистрации текущего сеанса обмена данными.
//  Используется для записи в журнал регистрации данных (ошибок, предупреждений, информации) с заданным именем события.
//  Соответствует параметру ИмяСобытия метода глобального контекста ЗаписьЖурналаРегистрации.
//
// КоличествоОтправленныхОбъектов - Число - Счетчик отправленных объектов.
//  Используется для определения количества отправленных объектов
//  для последующей фиксации в протоколе обмена.
//
Процедура ПриВыгрузкеДанных(СтандартнаяОбработка,
								Получатель,
								ИмяФайлаСообщения,
								ДанныеСообщения,
								КоличествоЭлементовВТранзакции,
								ИмяСобытияЖурналаРегистрации,
								КоличествоОтправленныхОбъектов) Экспорт
	
КонецПроцедуры

// Обработчик при загрузке данных.
// Используется для переопределения стандартной обработки загрузки данных.
// В данном обработчике должна быть реализована логика загрузки данных:
// необходимые проверки перед загрузкой данных, сериализация данных из файла сообщения или сериализация данных из
// потока.
// Формат сообщения для загрузки может быть произвольным.
// В случае ошибок при получении данных следует прерывать выполнение обработчика
// методом ВызватьИсключение с описанием ошибки.
//
// Параметры:
//
// СтандартнаяОбработка - Булево - В данный параметр передается признак выполнения
//  стандартной (системной) обработки события.
//  Если в теле процедуры-обработчика установить данному параметру значение Ложь,
//  стандартная обработка события производиться не будет.
//  Отказ от стандартной обработки не отменяет действие.
//  Значение по умолчанию: Истина.
//
// Отправитель - ПланОбменаСсылка - Узел плана обмена, для которого выполняется загрузка данных.
//
// ИмяФайлаСообщения - Строка - Имя файла, из которого требуется выполнить загрузку данных.
//  Если параметр не заполнен, то данные для загрузки передаются через параметр ДанныеСообщения.
//
// ДанныеСообщения - Произвольный - Параметр содержит данные, которые необходимо загрузить.
//  Если параметр ИмяФайлаСообщения пустой,
//  то данные для загрузки передаются через этот параметр.
//
// КоличествоЭлементовВТранзакции - Число - Определяет максимальное число элементов данных,
//  которые читаются из сообщения и записываются в базу данных в рамках одной транзакции.
//  При необходимости в обработчике следует реализовать логику записи данных в транзакции.
//  Значение параметра задается в настройках подсистемы обмена данными.
//
// ИмяСобытияЖурналаРегистрации - Строка - Имя события журнала регистрации текущего сеанса обмена данными.
//  Используется для записи в журнал регистрации данных (ошибок, предупреждений, информации) с заданным именем события.
//  Соответствует параметру ИмяСобытия метода глобального контекста ЗаписьЖурналаРегистрации.
//
// КоличествоПолученныхОбъектов - Число -Счетчик полученных объектов.
//  Используется для определения количества загруженных объектов
//  для последующей фиксации в протоколе обмена.
//
Процедура ПриЗагрузкеДанных(СтандартнаяОбработка,
								Отправитель,
								ИмяФайлаСообщения,
								ДанныеСообщения,
								КоличествоЭлементовВТранзакции,
								ИмяСобытияЖурналаРегистрации,
								КоличествоПолученныхОбъектов) Экспорт
	
КонецПроцедуры

// Обработчик регистрации изменений для начальной выгрузки данных.
// Используется для переопределения стандартной обработки регистрации изменений.
// При стандартной обработке будут зарегистрированы изменения всех данных из состава плана обмена.
// Если для плана обмена предусмотрены фильтры ограничения миграции данных,
// то использование этого обработчика позволит повысить производительность начальной выгрузки данных.
// В обработчике следует реализовать регистрацию изменений с учетом фильтров ограничения миграции данных.
// Если для плана обмена используются ограничения миграции по дате или по дате и организациям,
// то можно воспользоваться универсальной процедурой
// ОбменДаннымиСервер.ЗарегистрироватьДанныеПоДатеНачалаВыгрузкиИОрганизациям.
// Обработчик используется только для универсального обмена данными с использованием правил обмена
// и для универсального обмена данными без правил обмена и не используется для обменов в РИБ.
// Использование обработчика позволяет повысить производительность
// начальной выгрузки данных в среднем в 2-4 раза.
//
// Параметры:
//
// Получатель - ПланОбменаСсылка - Узел плана обмена, в который требуется выгрузить данные.
//
// СтандартнаяОбработка - Булево - В данный параметр передается признак выполнения стандартной (системной) обработки
//                                 события.
//  Если в теле процедуры-обработчика установить данному параметру значение Ложь, стандартная обработка события
//  производиться не будет.
//  Отказ от стандартной обработки не отменяет действие.
//  Значение по умолчанию - Истина.
//
Процедура РегистрацияИзмененийНачальнойВыгрузкиДанных(Знач Получатель, СтандартнаяОбработка, Отбор) Экспорт
	
	//// _Демо начало примера
	//Если    ТипЗнч(Получатель) = Тип("ПланОбменаСсылка._ДемоОбменСБиблиотекойСтандартныхПодсистем")
	//	ИЛИ ТипЗнч(Получатель) = Тип("ПланОбменаСсылка._ДемоОбменБезИспользованияПравилКонвертации")
	//	ИЛИ ТипЗнч(Получатель) = Тип("ПланОбменаСсылка._ДемоОбменВРаспределеннойИнформационнойБазе")
	//	ИЛИ ТипЗнч(Получатель) = Тип("ПланОбменаСсылка._ДемоОбменСБиблиотекойСтандартныхПодсистем225") Тогда
	//	
	//	СтандартнаяОбработка = Ложь;
	//	
	//	ЗначенияРеквизитов = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Получатель, "ИспользоватьОтборПоОрганизациям, ДатаНачалаВыгрузкиДокументов, Организации");
	//	
	//	Организации = ?(ЗначенияРеквизитов.ИспользоватьОтборПоОрганизациям, ЗначенияРеквизитов.Организации.Выгрузить().ВыгрузитьКолонку("Организация"), Неопределено);
	//	
	//	ОбменДаннымиСервер.ЗарегистрироватьДанныеПоДатеНачалаВыгрузкиИОрганизациям(Получатель, ЗначенияРеквизитов.ДатаНачалаВыгрузкиДокументов, Организации, Отбор);
	//	
	//КонецЕсли;
	//// _Демо конец примера
	
КонецПроцедуры

// Обработчик при коллизии изменений данных.
// Событие возникает при получении данных, если в текущей информационной базе изменен тот же объект,
// что получен из сообщения обмена и эти объекты различаются.
// Используется для переопределения стандартной обработки коллизий изменений данных.
// Стандартная обработка коллизий предполагает получение изменений от главного узла
// и игнорирование изменений, полученных от подчиненного узла.
// В данном обработчике должен быть переопределен параметр ПолучениеЭлемента,
// если требуется изменить поведение по умолчанию.
// В данном обработчике можно задать поведение системы при возникновении коллизии изменений данных в разрезе данных,
// в разрезе свойств данных, в разрезе отправителей или для всей информационной базы в целом, или для всех данных в
// целом.
// Обработчик вызывается как в обмене в распределенной информационной базе (РИБ),
// так и во всех остальных обменах, в том числе в обменах по правилам обмена.
//
// Параметры:
//  ЭлементДанных - Элемент данных, прочитанный из сообщения обмена данными.
//  Элементами данных могут быть КонстантаМенеджерЗначения.<Имя константы>,
//  объекты базы данных (кроме объекта "Удаление объекта"), наборы записей регистров, последовательностей или
//  перерасчетов.
//
// ПолучениеЭлемента - ПолучениеЭлементаДанных - Определяет, будет ли прочитанный элемент данных записан в базу данных
//                                               или нет в случае коллизии.
//  При вызове обработчика параметр имеет значение Авто, что означает действия по умолчанию
//  (принимать от главного, игнорировать от подчиненного).
//  Значение данного параметра может быть переопределено в обработчике.
//
// Отправитель - ПланОбменаСсылка - Узел плана обмена, от имени которого выполняется получение данных.
//
// ПолучениеОтГлавного - Булево -  В распределенной информационной базе обозначает признак получения данных от главного
//                                узла.
//  Истина - выполняется получение данных от главного узла, Ложь - от подчиненного.
//  В обменах по правилам обмена принимает значение Истина - если в правилах обмена приоритет объекта
//  при коллизии установлен в значение "Выше" (значение по умолчанию) или не указан;
//  Ложь - если в правилах обмена приоритет объекта при коллизии установлен в значение "Ниже" или "Совпадает".
//  Во всех остальных типах обмена данными параметр принимает значение Истина.
//
Процедура ПриКоллизииИзмененийДанных(Знач ЭлементДанных, ПолучениеЭлемента, Знач Отправитель, Знач ПолучениеОтГлавного) Экспорт
	
	//// _Демо начало примера
	
	//// Инвертируем стандартное поведение по умолчанию при коллизии изменений данных.
	//// Получаем данные от подчиненного узла и игнорируем получение данных от главного узла.
	//
	/////////////////////////////////////////////////////////////////////////////////
	//// Разбор коллизий в разрезе планов обмена.
	//
	//Если ТипЗнч(Отправитель) = Тип("ПланОбменаСсылка._ДемоОбменВРаспределеннойИнформационнойБазе") Тогда
	//	
	//	// Разбор коллизий для плана обмена "_ДемоОбменВРаспределеннойИнформационнойБазе".
	//	
	//	Если ТипЗнч(ЭлементДанных) = Тип("СправочникОбъект.Контрагенты") Тогда
	//		
	//		ПолучениеЭлемента = ОбменДаннымиСервер.ИнвертироватьПолучениеЭлементаДанныхПоУмолчанию(ПолучениеОтГлавного);
	//		
	//	ИначеЕсли ТипЗнч(ЭлементДанных) = Тип("СправочникОбъект._ДемоНоменклатура") Тогда
	//		
	//		ПолучениеЭлемента = ОбменДаннымиСервер.ИнвертироватьПолучениеЭлементаДанныхПоУмолчанию(ПолучениеОтГлавного);
	//		
	//	КонецЕсли;
	//	
	//ИначеЕсли ТипЗнч(Отправитель) = Тип("ПланОбменаСсылка._ДемоАвтономнаяРабота") Тогда
	//	
	//	// Разбор коллизий для плана обмена "_ДемоАвтономнаяРабота".
	//	
	//	Если ТипЗнч(ЭлементДанных) = Тип("СправочникОбъект.Контрагенты") Тогда
	//		
	//		ПолучениеЭлемента = ОбменДаннымиСервер.ИнвертироватьПолучениеЭлементаДанныхПоУмолчанию(ПолучениеОтГлавного);
	//		
	//	КонецЕсли;
	//	
	//КонецЕсли;
	//
	/////////////////////////////////////////////////////////////////////////////////
	//// Разбор коллизий для всех планов обмена.
	//
	//Если ТипЗнч(ЭлементДанных) = Тип("СправочникОбъект.Организации") Тогда
	//	
	//	ПолучениеЭлемента = ОбменДаннымиСервер.ИнвертироватьПолучениеЭлементаДанныхПоУмолчанию(ПолучениеОтГлавного);
	//	
	//КонецЕсли;
	
	//// _Демо конец примера
	
КонецПроцедуры

// Устарела. Следует использовать ПриОпределенииПрефиксаИнформационнойБазыПоУмолчанию.
//
Функция ПрефиксИнформационнойБазыПоУмолчанию() Экспорт
	
КонецФункции

// Обработчик начальной настройки ИБ после создания узла РИБ.
// Вызывается в момент первого запуска подчиненного узла РИБ (в том числе АРМ).
Процедура ПриНастройкеПодчиненногоУзлаРИБ() Экспорт
	
КонецПроцедуры

// Получает доступные для использования версии универсального формата EnterpriseData
//
// Параметры:
// ВерсииФормата - Соответствие - Соответствие номера версии формата,
//  общему модулю, в котором находятся обработчики выгрузки/загрузки для данной версии.
//
// Пример тела процедуры:
//  ВерсииФормата.Вставить("1.0.beta", _ДемоМенеджерОбменаЧерезУниверсальныйФормат);
Процедура ПриПолученииДоступныхВерсийФормата(ВерсииФормата) Экспорт
	
	//// _Демо начало примера
	// ВерсииФормата.Вставить("1.0.beta", _ДемоМенеджерОбменаЧерезУниверсальныйФормат);
	// ВерсииФормата.Вставить("1.0",      _ДемоМенеджерОбменаЧерезУниверсальныйФормат);
	//// _Демо конец примера
	
КонецПроцедуры

#КонецОбласти
