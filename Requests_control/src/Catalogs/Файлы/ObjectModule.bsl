
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
// Обработка события ПередЗаписью
//
Процедура ПередЗаписью(Отказ)
	
	Если Не ЗначениеЗаполнено(Ссылка) Тогда
		ДополнительныеСвойства.Вставить("ЭтоНовый", Истина);
	КонецЕсли;
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если ДополнительныеСвойства.Свойство("КонвертацияФайлов") Тогда
		Возврат;
	КонецЕсли;
	
	Если ДополнительныеСвойства.Свойство("РазмещениеФайловВТомах") Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(ВладелецФайла) Тогда
		
		Если ОбновлениеИнформационнойБазы.ВыполняетсяОбновлениеИнформационнойБазы() Тогда
			
			ЗаписьЖурналаРегистрации(
				НСтр("ru = 'Файлы.Ошибка записи файла при обновлении ИБ'",
				     ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()),
				УровеньЖурналаРегистрации.Ошибка, , Ссылка,
				СтрШаблон(
				НСтр("ru = 'В файле ""%1"" не заполнен ВладелецФайла'"),
				Строка(Ссылка)));
				
		Иначе	
				
			ВызватьИсключение НСтр("ru = 'Нельзя записать файл, если не указан владелец файла.'");
			
		КонецЕсли;	
		
	КонецЕсли;
	
	Если Не ЭтоНовый() Тогда
		
		ИзменилсяТолькоВладелец = Ложь;
		
		Если ВладелецИзменился() Тогда
			
			СтрокаОшибки = "";
			
			ИменаРеквизитов = Новый Массив;
			Для Каждого Реквизит Из Метаданные.Справочники["Файлы"].Реквизиты Цикл
				ИменаРеквизитов.Добавить(Реквизит.Имя);
			КонецЦикла;
			Для Каждого Реквизит Из Метаданные.Справочники["Файлы"].СтандартныеРеквизиты Цикл
				ИменаРеквизитов.Добавить(Реквизит.Имя);
			КонецЦикла;
			
			ИзменилсяТолькоВладелец = Истина;
			
			ПрежниеЗначенияРеквизитов = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Ссылка, ИменаРеквизитов);
			Для Каждого ПрежнееЗначениеРеквизита Из ПрежниеЗначенияРеквизитов Цикл
				ИмяРеквизита = ПрежнееЗначениеРеквизита.Ключ;
				ЗначениеРеквизита = ПрежнееЗначениеРеквизита.Значение;
				
				ЗначенияРеквизитовРазличаются = Ложь;
				Если ТипЗнч(ЗначениеРеквизита) = Тип("ХранилищеЗначения") Тогда
					ЗначенияРеквизитовРазличаются = (ЗначениеРеквизита.Получить() <> ЭтотОбъект[ИмяРеквизита].Получить());
				Иначе
					ЗначенияРеквизитовРазличаются = (ЗначениеРеквизита <> ЭтотОбъект[ИмяРеквизита]);
				КонецЕсли;
				
				Если ИмяРеквизита <> "ВладелецФайла" И ЗначенияРеквизитовРазличаются Тогда
					ИзменилсяТолькоВладелец = Ложь;
					Прервать;
				КонецЕсли;
			КонецЦикла;
			
		КонецЕсли;
		
		ЕстьПометкаУдаленияВИБ = ПометкаУдаленияВИБ();
		УстановленаПометкаУдаления = ПометкаУдаления И Не ЕстьПометкаУдаленияВИБ;
		
		ИзмененаПометкаУдаления = Ложь;
		Если ДополнительныеСвойства.Свойство("ИзмененаПометкаУдаления") Тогда
			ИзмененаПометкаУдаления = ДополнительныеСвойства.ИзмененаПометкаУдаления;
		Иначе
			ИзмененаПометкаУдаления = (ПометкаУдаления <> ЕстьПометкаУдаленияВИБ);
			ДополнительныеСвойства.Вставить("ИзмененаПометкаУдаления", ИзмененаПометкаУдаления);
		КонецЕсли;
		
		ЗаписьПодписанногоОбъекта = Ложь;
		Если ДополнительныеСвойства.Свойство("ЗаписьПодписанногоОбъекта") Тогда
			ЗаписьПодписанногоОбъекта = ДополнительныеСвойства.ЗаписьПодписанногоОбъекта;
		КонецЕсли;	
		
		Если Не ПометкаУдаления И Не ТекущаяВерсия.Пустая() Тогда
			
			РеквизитыТекущейВерсии = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ТекущаяВерсия, 
				"ПолноеНаименование");
			
			// Проверим равенство имени файла и его текущей версии
			// Если имена отличаются - имя у версии должно стать как у карточки с файлом
			Если РеквизитыТекущейВерсии.ПолноеНаименование <> ПолноеНаименование Тогда
				Объект = ТекущаяВерсия.ПолучитьОбъект();
				Если Объект <> Неопределено И Объект.Ссылка <> Неопределено Тогда
					ЗаблокироватьДанныеДляРедактирования(Объект.Ссылка);
					УстановитьПривилегированныйРежим(Истина);
					Объект.ПолноеНаименование = ПолноеНаименование;
					Объект.ДополнительныеСвойства.Вставить("ПереименованиеФайла", Истина); // чтобы не сработала подписка СкопироватьРеквизитыВерсииФайловВФайл
					Объект.Записать();
					УстановитьПривилегированныйРежим(Ложь);
				КонецЕсли;	
			КонецЕсли;
			
		КонецЕсли;
		
		Если ИзмененаПометкаУдаления Тогда
			
			// Проверка права "Пометка на удаление".
			Если НЕ РаботаСФайламиПереопределяемый.ПометкаУдаленияРазрешена(Ссылка) Тогда
				ВызватьИсключение СтрШаблон(
					НСтр("ru = 'У вас нет прав для установки пометки удаления файла ""%1"".'"),
					Строка(Ссылка));
			КонецЕсли;
			
			// Попытка установить пометку удаления
			Если УстановленаПометкаУдаления И ЗначениеЗаполнено(Редактирует) Тогда
				ВызватьИсключение СтрШаблон(
				                    НСтр("ru = 'Нельзя удалить файл ""%1"", т.к. он занят для редактирования пользователем ""%2"".'"),
				                    ПолноеНаименование,
				                    Строка(Редактирует) );
			КонецЕсли;
			
			СтрокаОшибки = "";
			Если Не РаботаСФайламиПереопределяемый.ВозможноУдалитьФайл(ЭтотОбъект, СтрокаОшибки) Тогда
				ВызватьИсключение СтрокаОшибки;
			КонецЕсли;
			
		КонецЕсли;
		
		НаименованиеВИБ = НаименованиеВИБ();
		Если ПолноеНаименование <> НаименованиеВИБ Тогда 
			Если ЗначениеЗаполнено(Редактирует) Тогда
				ВызватьИсключение СтрШаблон(
				                    НСтр("ru = 'Нельзя переименовать файл ""%1"", т.к. он занят для редактирования пользователем ""%2"".'"),
				                    НаименованиеВИБ,
				                    Строка(Редактирует) );
			КонецЕсли;
		КонецЕсли;
		
	КонецЕсли;
	
	Наименование = СокрЛП(ПолноеНаименование);
	
КонецПроцедуры

Функция ВладелецИзменился()
	
	Если ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Ссылка, "ВладелецФайла") = ВладелецФайла Тогда
		Возврат Ложь;
	Иначе
		Возврат Истина;
	КонецЕсли;	
	
КонецФункции	

// Возвращает текущее значение пометки удаления в информационной базе
Функция ПометкаУдаленияВИБ()
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	Файлы.ПометкаУдаления
		|ИЗ
		|	Справочник.Файлы КАК Файлы
		|ГДЕ
		|	Файлы.Ссылка = &Ссылка";

	Запрос.УстановитьПараметр("Ссылка", Ссылка);

	Результат = Запрос.Выполнить();

	Если Не Результат.Пустой() Тогда
		Выборка = Результат.Выбрать();
		Выборка.Следующий();
		Возврат Выборка.ПометкаУдаления;
	КонецЕсли;
	
	Возврат Неопределено;
КонецФункции

// Возвращает текущее значение наименования в информационной базе
Функция НаименованиеВИБ()
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Файлы.ПолноеНаименование
	|ИЗ
	|	Справочник.Файлы КАК Файлы
	|ГДЕ
	|	Файлы.Ссылка = &Ссылка";
	
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Результат = Запрос.Выполнить();
	
	Если Не Результат.Пустой() Тогда
		Выборка = Результат.Выбрать();
		Выборка.Следующий();
		Возврат Выборка.ПолноеНаименование;
	КонецЕсли;
	
	Возврат Неопределено;	
	
КонецФункции

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	Если ЭтоНовый() Тогда
		ДатаСоздания = ТекущаяДата();
		ХранитьВерсии = Истина;
		ИндексКартинки = ФайловыеФункцииКлиентСервер.ПолучитьИндексПиктограммыФайла(Неопределено);
		
		Автор = ПользователиКлиентСервер.ТекущийПользователь();
		ДатаСоздания = ТекущаяДата();
	КонецЕсли;
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка
		И ЗначениеЗаполнено(ОбменДанными.Отправитель)
		И ОбменДаннымиПовтИсп.ЭтоУзелРаспределеннойИнформационнойБазы(ОбменДанными.Отправитель) Тогда
		Возврат;
	КонецЕсли;
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

#КонецЕсли