////////////////////////////////////////////////////////////////////////////////
// Подсистема "Обновление конфигурации".
//  
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Определяет короткое имя (идентификатор) конфигурации.
//
// Параметры:
//	КраткоеИмя - Строка- короткое имя конфигурации.
//
Процедура ПриОпределенииКраткогоИмениКонфигурации(КраткоеИмя) Экспорт
	
	Если СтандартныеПодсистемыСервер.ЭтоБазоваяВерсияКонфигурации() Тогда
		КраткоеИмя = "AppealsBase";
	Иначе
		КраткоеИмя = "Appeals";
	КонецЕсли;
	
КонецПроцедуры

// Получает адрес веб-сервера поставщика конфигурации, на котором находится
// информация о доступных обновлениях ("открытая" часть веб-сайта).
//
// Параметры:
//	АдресСервера - Строка - адрес веб-сервера.
//
// Примеры реализации:
//	АдресСервера = "localhost";  // локальный веб-сервер для тестирования.
//
Процедура ПриОпределенииАдресаСервераДляПроверкиНаличияОбновления(АдресСервера) Экспорт
	
КонецПроцедуры

// Получить адрес ресурса на веб-сервере для проверки наличия обновлений
// (на "открытой" части веб-сайта).
//
// Параметры:
//	АдресРесурса - Строка - Адрес ресурса для проверки наличия обновления.
//
Процедура ПриОпределенииАдресаРесурсаДляПроверкиНаличияОбновления(АдресРесурса) Экспорт
	
КонецПроцедуры

// Получает адрес веб-сайта с каталогом обновлений ("закрытая" часть веб-сайта).
//
// Параметры:
//	АдресКаталогаОбновлений - Строка - Адрес каталога обновлений.
//
// Примеры реализации:
//	АдресКаталогаОбновлений = "localhost/tmplts/"; // локальный веб-сервер для тестирования.
//
Процедура ПриОпределенииАдресаКаталогаОбновлений(АдресКаталогаОбновлений) Экспорт
	
КонецПроцедуры

// Определяет группу версий конфигурации. Для каждой конфигурации возможно сквозное
// (без разрыва цепочки и необходимости запуска) обновление в пределах одной группы.
//
// Параметры:
//    ГруппаВерсий - Число - Группа версий конфигурации.
//
Процедура ПриОпределенииГруппыВерсий(ГруппаВерсий) Экспорт
	
КонецПроцедуры

// Скачивает из Интернета файл проверки наличия обновлений.
//
Функция ПолучитьФайлПроверкиНаличияОбновлений() Экспорт
	
	НастройкиОбновления = ОбновлениеКонфигурации.ПолучитьНастройкиОбновления();
	АдресРесурсовДляПроверкиНаличияОбновления = АдресРесурсовДляПроверкиНаличияОбновления(
		НастройкиОбновления);
	ИмяФайлаПроверкиНаличияОбновления = "UpdInfo.txt";
	
	URL = СтрШаблон("%1%2%3",
		НастройкиОбновления.АдресСервераДляПроверкиНаличияОбновления,
		АдресРесурсовДляПроверкиНаличияОбновления,
		ИмяФайлаПроверкиНаличияОбновления);
	
	ВременныйФайл = ПолучитьИмяВременногоФайла("txt");
	Попытка
		
		ПараметрыПолучения = Новый Структура("ПутьДляСохранения", ВременныйФайл);
		Результат = ПолучениеФайловИзИнтернета.СкачатьФайлНаСервере(URL, ПараметрыПолучения);
		Если Результат.Статус <> Истина Тогда
			ВызватьИсключение Результат.СообщениеОбОшибке;
		КонецЕсли;
		
		ПараметрыФайлаПроверкиОбновления = ПараметрыДистрибутива(ВременныйФайл);
		УдалитьФайлы(ВременныйФайл);
		
	Исключение
		ТекстОшибки = СтрШаблон(НСтр("ru = 'Не удалось получить файл проверки обновления:
			|%1'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()), ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		ЗаписьЖурналаРегистрации(
			ОбновлениеКонфигурации.СобытиеЖурналаРегистрации(),
			УровеньЖурналаРегистрации.Ошибка,,,
			ТекстОшибки);
		УдалитьФайлы(ВременныйФайл);
		Возврат Неопределено;
	КонецПопытки;
	
	Возврат ПараметрыФайлаПроверкиОбновления;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Чтение данных по обновлению из файла ИмяФайлаПроверкиНаличияОбновления (UpdInfo.txt).
// Вычисляются: 
//		номер версии обновления на сервере, 
//		номера версий, с которых производится обновление (раздляются символом ";")
//		дата публикации обновления.
//
// Параметры:
//  ИмяФайла - полное имя файла UpdInfo.txt.
// 
// Возвращаемое значение:
//  Структура: 
//		Version - версия обновления.
//		FromVersions - с каких версий обновляет.
//		UpdateDate - дата опубликования.
//  Строка - описание ошибки, если файл не найден или не содержит нужных значений.
//
Функция ПараметрыДистрибутива(Знач ИмяФайла)
	
	Файл = Новый Файл(ИмяФайла);
	Если Не Файл.Существует() Тогда
		ВызватьИсключение НСтр("ru = 'Файл описания обновлений не получен'");
	КонецЕсли;
	
	ТекстовыйДокумент = Новый ТекстовыйДокумент(); 
	ТекстовыйДокумент.Прочитать(Файл.ПолноеИмя);
	
	ПараметрыКомплекта = Новый Структура();
	Для НомерСтроки = 1 По ТекстовыйДокумент.КоличествоСтрок() Цикл
		ВременнаяСтрока = НРег(СокрЛП(ТекстовыйДокумент.ПолучитьСтроку(НомерСтроки)));
		Если ПустаяСтрока(ВременнаяСтрока) Тогда
			Продолжить;
		КонецЕсли; 
		Если СтрНайти(ВременнаяСтрока, "fromversions=") > 0 Тогда
			ВременнаяСтрока = СокрЛП(Сред(ВременнаяСтрока, СтрНайти(ВременнаяСтрока, "fromversions=") + СтрДлина("fromversions=")));
			ВременнаяСтрока = ?(Лев(ВременнаяСтрока,1)=";","",";") + ВременнаяСтрока + ?(Прав(ВременнаяСтрока,1)=";","",";");
			ПараметрыКомплекта.Вставить("FromVersions", ВременнаяСтрока);
		ИначеЕсли СтрНайти(ВременнаяСтрока,"version=")>0 Тогда
			ПараметрыКомплекта.Вставить("Version",Сред(ВременнаяСтрока, СтрНайти(ВременнаяСтрока, "version=") + СтрДлина("version=")));
		ИначеЕсли СтрНайти(ВременнаяСтрока,"updatedate=")>0 Тогда
			// формат даты = Дата, 
			ВременнаяСтрока = Сред(ВременнаяСтрока, СтрНайти(ВременнаяСтрока,"updatedate=") + СтрДлина("updatedate="));
			Если СтрДлина(ВременнаяСтрока)>8 Тогда
				Если СтрНайти(ВременнаяСтрока,".")=5 Тогда
					// дата в формате  ГГГГ.ММ.ДД
					ВременнаяСтрока = СтрЗаменить(ВременнаяСтрока,".","");
				ИначеЕсли СтрНайти(ВременнаяСтрока,".")=3 Тогда
					// дата в формате ДД.ММ.ГГГГ
					ВременнаяСтрока = Прав(ВременнаяСтрока,4)+Сред(ВременнаяСтрока,4,2)+Лев(ВременнаяСтрока,2);
				Иначе 
					// дата в формате ГГГГММДД
				КонецЕсли;
			КонецЕсли;
			ПараметрыКомплекта.Вставить("UpdateDate",Дата(ВременнаяСтрока));
		Иначе
			ВызватьИсключение НСтр("ru = 'Неверный формат сведений о наличии обновлений'");
		КонецЕсли;
	КонецЦикла;
	
	Если ПараметрыКомплекта.Количество() <> 3 Тогда 
		ВызватьИсключение НСтр("ru = 'Неверный формат сведений о наличии обновлений'");
	КонецЕсли;
	
	Возврат ПараметрыКомплекта;
	
КонецФункции

// Получить адрес страницы на веб-сервере поставщика конфигурации, на которой находится
// информация о доступных обновлениях.
//
// Параметры:
//  НастройкиОбновления - Структура - Настройки обновления.
//
// Возвращаемое значение:
//   Строка - Адрес веб-страницы.
//
Функция АдресРесурсовДляПроверкиНаличияОбновления(НастройкиОбновления)
	
	КороткоеИмяКонфигурации = НастройкиОбновления.КороткоеИмяКонфигурации;
	КороткоеИмяКонфигурации = СтрЗаменить(КороткоеИмяКонфигурации, "\", "/");
	
	Результат = СтрШаблон("%1%2/", ОбновлениеКонфигурацииКлиентСервер.ДобавитьКонечныйРазделительПути(
		НастройкиОбновления.АдресРесурсаДляПроверкиНаличияОбновления), КороткоеИмяКонфигурации);
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти