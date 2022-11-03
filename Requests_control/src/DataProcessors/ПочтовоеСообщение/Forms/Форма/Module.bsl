#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ПараметрыОтправки = ПараметрыОтправкиПочтовогоСообщенияВызовСервера.Создать();
	
	ДоступныеПрофили = ПараметрыОтправкиПочтовогоСообщения.ПолучитьСписокДоступныхПрофилей(ПараметрыОтправки);
	Если ДоступныеПрофили.Количество() = 0 Тогда
		Отказ = Истина;
		СтандартнаяОбработка = Ложь;
		ВызватьИсключение НСтр("ru = 'У вас не настроено ни одного профиля легкой почты для отправки.
		|Настроить профили можно в форме ""Персональные настройки - Легкая почта"".'");
	КонецЕсли;	
	
	ЗаполнитьРеквизитыФормы(Параметры.Объекты);
	Если Параметры.Свойство("Кому") Тогда
		СтрокаДанных = Получатели.Добавить();
		СтрокаДанных.ТипАдреса = НСтр("ru='Кому:'");
		СтрокаДанных.Адрес = Параметры.Кому;
	КонецЕсли;
	
	Если Параметры.Свойство("СсылкаMailto") Тогда
		
		ДанныеMailto = РаботаС_HTML.РазобратьСсылкуMailto(Параметры.СсылкаMailto);
		
		// Кому
		Если ДанныеMailto.Свойство("АдресатыКому") Тогда
			Для Каждого Адресат Из ДанныеMailto.АдресатыКому Цикл
				СтрокаДанных = Получатели.Добавить();
				СтрокаДанных.ТипАдреса = НСтр("ru='Кому:'");
				СтрокаДанных.Адрес = Адресат.Адрес;
			КонецЦикла;
		КонецЕсли;
		
		// Копии
		Если ДанныеMailto.Свойство("АдресатыКопия") Тогда
			Для Каждого Адресат Из ДанныеMailto.АдресатыКопия Цикл
				СтрокаДанных = Получатели.Добавить();
				СтрокаДанных.ТипАдреса = НСтр("ru='Копия:'");
				СтрокаДанных.Адрес = Адресат.Адрес;
			КонецЦикла;
		КонецЕсли;
		
		// Скрытые копии
		Если ДанныеMailto.Свойство("АдресатыСкрытаяКопия") Тогда
			Для Каждого Адресат Из ДанныеMailto.АдресатыСкрытаяКопия Цикл
				СтрокаДанных = Получатели.Добавить();
				СтрокаДанных.ТипАдреса = НСтр("ru='Скрытая копия:'");
				СтрокаДанных.Адрес = Адресат.Адрес;
			КонецЦикла;
		КонецЕсли;
		
		// Тема
		Если ДанныеMailto.Свойство("ТемаПисьма") Тогда
			Тема = ДанныеMailto.ТемаПисьма;
		КонецЕсли;
		
		// Текст
		Если ДанныеMailto.Свойство("ТекстПисьма") Тогда
			Содержание = ДанныеMailto.ТекстПисьма;
		КонецЕсли;
		
	КонецЕсли;
	
	Если Параметры.Свойство("СписокФайлов") Тогда
		
		ВложенияВПисьмо = Параметры.СписокФайлов;
		
		// помечаем те вложения, которые являются путями к файлам на клиенте
		Для Каждого ОписаниеВложение из ВложенияВПисьмо Цикл
			
			Если ТипЗнч(ОписаниеВложение) = Тип("Структура") Тогда
				
				Если ЭтоАдресВременногоХранилища(ОписаниеВложение.АдресВоВременномХранилище) Тогда
					
					СтруктураИмениФайла = ОбщегоНазначенияКлиентСервер.РазложитьПолноеИмяФайла(ОписаниеВложение.Представление);
					
					ВложенияСтрока = Вложения.Добавить();
					
					ВложенияСтрока.ИмяФайла = СтруктураИмениФайла.Имя;
					ВложенияСтрока.ИндексКартинки = 
						ФайловыеФункцииКлиентСервер.ПолучитьИндексПиктограммыФайла(СтруктураИмениФайла.Расширение);
						
					ДвоичныеДанные = ПолучитьИзВременногоХранилища(ОписаниеВложение.АдресВоВременномХранилище);
					ВложенияСтрока.Размер = ДвоичныеДанные.Размер();
					
					ВложенияСтрока.РазмерПредставление = РаботаСоСтроками.ПолучитьРазмерСтрокой(ВложенияСтрока.Размер);
					ВложенияСтрока.ПометкаУдаления = Ложь;
					ВложенияСтрока.ИмяФайлаНаДиске = "";
					ВложенияСтрока.Редактирует = Неопределено;
					ВложенияСтрока.РедактируетТекущийПользователь = Ложь;
					ВложенияСтрока.Представление = СтруктураИмениФайла.ИмяБезРасширения;
					
					ВложенияСтрока.Расположение = "ВременноеХранилище";
					ВложенияСтрока.Ссылка = Неопределено;
					ВложенияСтрока.Адрес = ПоместитьВоВременноеХранилище(ДвоичныеДанные, УникальныйИдентификатор);
					ВложенияСтрока.ИмяФайла = ОписаниеВложение.Представление;
					
					
				КонецЕсли;
				
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЕсли;	
	
	СписокВыбораКому = ХранилищеСистемныхНастроек.Загрузить(ИмяФормы, "ПолучателиПредставлениеКому");
	Для Каждого СтрокаСписка Из СписокВыбораКому Цикл
		Элементы.ПолучателиПредставление.СписокВыбора.Добавить(СтрокаСписка.Значение);
	КонецЦикла;	
	
	Элементы.ПолучателиПредставление.КнопкаВыпадающегоСписка = СписокВыбораКому.Количество() <> 0;
	
	Если Вложения.Количество() = 0 Тогда
		Элементы.ГруппаВложения.Видимость = Ложь;
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	РасширениеРаботыСКриптографиейПодключено = ПодключитьРасширениеРаботыСКриптографией();
	
	Если Получатели.Количество() = 0 Тогда
		ПодключитьОбработчикОжидания("УстановитьТекущийЭлементПолучатель", 0.2, Истина);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	Если ОбщегоНазначенияДокументооборотКлиент.ПриЗакрытии(ЗавершениеРаботы) Тогда
		Возврат;
	КонецЕсли;
	
	ПриЗакрытииСервер();
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	Если ТипЗнч(Профиль) = Тип("СправочникСсылка.УчетныеЗаписиЭлектроннойПочты") Тогда
		
		ЕстьАдреса = Ложь;
		Для Каждого Строка Из Получатели Цикл
			
			Если Не ПустаяСтрока(Строка.Адрес) Тогда
				ЕстьАдреса = Истина;
				
				АдресИнфо = РаботаСоСтроками.РазложитьПредставлениеАдресаЭлектроннойПочты(Строка.Адрес);
				Если АдресИнфо.Адрес = "" Тогда
					
					Отказ = Истина;
					ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
						СтрШаблон(НСтр("ru = 'Неверный адрес (%1).'"), Строка.Адрес),,
						"Получатели");
					
				КонецЕсли;	
				
			КонецЕсли;	
			
		КонецЦикла;	
		
		Если Не ЕстьАдреса Тогда
			
			Отказ = Истина;
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				НСтр("ru = 'Не указано ни одного адреса получателя.'"),,
				"Получатели");
			
		КонецЕсли;	
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

#КонецОбласти

#Область ОбработчикиСобытийЭлементовПолучатели

&НаКлиенте
Процедура ПолучателиПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	РежимДобавленияАдресата = Истина;
КонецПроцедуры

&НаКлиенте
Процедура ПолучателиПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	Если РежимДобавленияАдресата Тогда
		
		Элемент.ТекущийЭлемент = Элементы.ПолучателиПредставление;
		РежимДобавленияАдресата = Ложь;
		
	КонецЕсли;
	
	СтрокаДанных = Получатели.НайтиПоИдентификатору(Элементы.Получатели.ТекущаяСтрока);
	СтрокаДанных.ТипАдреса = НСтр("ru='Кому:'");	
	
КонецПроцедуры

&НаКлиенте
Процедура ПолучателиПредставлениеАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Текст) Тогда 
		ДанныеВыбора = СформироватьДанныеВыбораПолучателя(Текст);
		
		Если ДанныеВыбора.Количество() <> 0 Тогда
			СтандартнаяОбработка = Ложь;
		КонецЕсли;	
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПолучателиПредставлениеОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если Элементы.Получатели.ТекущиеДанные <> Неопределено Тогда
	
		Если ТипЗнч(ВыбранноеЗначение) = Тип("Строка") Тогда
			Элементы.Получатели.ТекущиеДанные.Адрес = ВыбранноеЗначение;
			Элементы.Получатели.ТекущиеДанные.Контакт = Неопределено;
		КонецЕсли;	
		
		Если ТипЗнч(ВыбранноеЗначение) = Тип("Структура") Тогда
			Элементы.Получатели.ТекущиеДанные.Адрес = ВыбранноеЗначение.Представление;
			Элементы.Получатели.ТекущиеДанные.Контакт = ВыбранноеЗначение.Ссылка;
		КонецЕсли;	
		
	КонецЕсли;	
	
	Модифицированность = Истина;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовВложения

&НаКлиенте
Процедура ТаблицаФайловВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ОткрытьВложениеКлиент();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОткрытьВложение(Команда)
	
	ОткрытьВложениеКлиент();
	
КонецПроцедуры

&НаКлиенте
Процедура Отправить(Команда)
	
	ОчиститьСообщения();
	
	Если Не ПроверитьЗаполнение() Тогда
		Возврат;
	КонецЕсли;
	
	ЗаполнитьПараметрыОтправкиКлиент();
	Состояние(НСтр("ru = 'Идет отправка письма. Пожалуйста, подождите...'"));
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"ОтправитьПродолжение",
		ЭтотОбъект);
	ЛегкаяПочтаКлиент.Отправить(ОписаниеОповещения, ПараметрыОтправки);
	Возврат;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтправитьПродолжение(Результат, Параметры) Экспорт
	
	Если Не Результат.КодВозврата Тогда
		ТекстПредупреждения = НСтр("ru = 'Не удалось отправить сообщение!'");
		ДобавитьЗначениеКСтрокеЧерезРазделитель(ТекстПредупреждения, Символы.ПС, Результат.СообщениеОбОшибке);
		ПоказатьПредупреждение(, ТекстПредупреждения);
		Возврат;
	КонецЕсли;
	Состояние(НСтр("ru = 'Письмо отправлено.'"));
	Закрыть();
	
КонецПроцедуры

&НаСервере
Процедура СформироватьТекстПисьма()
	
	Контекст = Новый Структура;
	Контекст.Вставить("Тема", "");
	Контекст.Вставить("СодержаниеДокументов", "");
	Контекст.Вставить("ТекстОснований", "");
	Контекст.Вставить("КоличествоОснований", 0);
	Для каждого ЭлементДерева Из ТаблицаФайлов.ПолучитьЭлементы() Цикл
		ДобавитьОписаниеВложения(ЭлементДерева, Контекст);
	КонецЦикла;
	
	Содержание = "";
	ДобавитьЗначениеКСтрокеЧерезРазделитель(
		Содержание,
		Символы.ПС + Символы.ПС,
		Контекст.СодержаниеДокументов);
	
	ОтправкаПодписьСообщения = ПараметрыОтправкиПочтовогоСообщения.Свойство(
		ПараметрыОтправки,
		"ОтправкаПодписьСообщения");
	
	ДобавитьЗначениеКСтрокеЧерезРазделитель(
		Содержание,
		Символы.ПС + Символы.ПС,
		ОтправкаПодписьСообщения);
	
	Если Контекст.КоличествоОснований > 0 Тогда
		Если Контекст.КоличествоОснований = 1 Тогда
			Тема = Контекст.Тема;
		КонецЕсли;
		ДобавитьЗначениеКСтрокеЧерезРазделитель(Содержание, Символы.ПС + Символы.ПС, Контекст.ТекстОснований);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ПриЗакрытииСервер()
	
	Для Каждого Строка Из Получатели Цикл
		Если Не ПустаяСтрока(Строка.Адрес) Тогда
			
			Если СписокВыбораКому.НайтиПоЗначению(Строка.Адрес) = Неопределено Тогда
				СписокВыбораКому.Добавить(Строка.Адрес);
			КонецЕсли;	
			
		КонецЕсли;
	КонецЦикла;	
			
	ХранилищеСистемныхНастроек.Сохранить(ИмяФормы, "ПолучателиПредставлениеКому", СписокВыбораКому);
			
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьРеквизитыФормы(Объекты)
	
	// Установим профиль.
	Профиль = ПараметрыОтправкиПочтовогоСообщения.ПолучитьПрофиль(ПараметрыОтправки);
	Если Параметры.Свойство("ВебКлиент") И Параметры.ВебКлиент = Истина И ТипЗнч(Профиль) = Тип("Строка") Тогда
		Профиль = Неопределено;
	КонецЕсли;
	
	// Формирование таблицы вложений
	ДобавитьФайлыОбъектов(Объекты);
	
	// Заполнение получателей из переданных объектов
	ЗаполнитьПолучателей(Объекты);
	
	// Формирование текста письма
	СформироватьТекстПисьма();
	
КонецПроцедуры

&НаСервере
Процедура ДобавитьФайлыОбъектов(Объекты)
	
	Для каждого Объект Из Объекты Цикл
		ДобавитьОбъект(ТаблицаФайлов, Объект);
	КонецЦикла;
	ПересчитатьРазмерВложений();
	
	ДобавитьВложенияИзДерева(ТаблицаФайлов.ПолучитьЭлементы());
	
КонецПроцедуры

&НаСервере
Процедура ДобавитьВложенияИзДерева(ДеревоЭлементы)
	
	Для каждого ДеревоСтрока Из ДеревоЭлементы Цикл
		
		Если ДеревоСтрока.ЭтоФайл Тогда
			ВложенияСтрока = Вложения.Добавить();
			
			ВложенияСтрока.ИмяФайла = "";
			ВложенияСтрока.ИндексКартинки = ДеревоСтрока.ИндексКартинки;
			ВложенияСтрока.Размер = ДеревоСтрока.Размер;
			ВложенияСтрока.Расположение = "Ссылка";
			ВложенияСтрока.РазмерПредставление = РаботаСоСтроками.ПолучитьРазмерСтрокой(ДеревоСтрока.Размер);
			ВложенияСтрока.ПометкаУдаления = Ложь;
			ВложенияСтрока.ИмяФайлаНаДиске = "";
			ВложенияСтрока.Редактирует = Неопределено;
			ВложенияСтрока.РедактируетТекущийПользователь = Ложь;
			ВложенияСтрока.Представление = ДеревоСтрока.Наименование;
			ВложенияСтрока.Адрес = Неопределено;
			Если ДеревоСтрока.ЭтоПодпись Тогда
				ВложенияСтрока.Расположение = "ВременноеХранилище";
				ВложенияСтрока.Ссылка = Неопределено;
				ВложенияСтрока.Адрес = ДеревоСтрока.Подпись;
				ВложенияСтрока.ИмяФайла = ДеревоСтрока.ИмяФайла;
			Иначе
				ВложенияСтрока.Расположение = "Ссылка";
				ВложенияСтрока.Ссылка = ДеревоСтрока.Ссылка;
				ВложенияСтрока.Адрес = Неопределено;
			КонецЕсли;
		КонецЕсли;
		
		ДобавитьВложенияИзДерева(ДеревоСтрока.ПолучитьЭлементы());
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ДобавитьОбъект(Корень, Объект, ДобавлятьДокументыТолькоСФайлами = Ложь)
	
	//Если ДоговорныеДокументыКлиентСервер.ЭтоФайл(Объект) Тогда
	//	ФайлыИнфо = ПолучитьИнформациюОФайлах(Новый Структура("Ссылка", Объект));
	//	ДобавитьФайл(Корень, ФайлыИнфо[0]);
	//ИначеЕсли ДоговорныеДокументыКлиентСервер.ЭтоДоговорнойДокумент(Объект) Тогда
	//	ДобавитьДокумент(Корень, Объект, ДобавлятьДокументыТолькоСФайлами);
	//КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ДобавитьДокумент(Корень, Ссылка, ДобавлятьДокументыТолькоСФайлами = Ложь)
	
	ФайлыДокументаИнфо = ПолучитьИнформациюОФайлах(Новый Структура("ВладелецФайла, ПометкаУдаления", Ссылка, Ложь));
	Если ДобавлятьДокументыТолькоСФайлами И ФайлыДокументаИнфо.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	СтрокаДокумент = ТаблицаФайловДобавитьСтроку(Корень, "Документ", Ссылка);
	Для каждого ФайлИнфо Из ФайлыДокументаИнфо Цикл
		ДобавитьФайл(СтрокаДокумент, ФайлИнфо);
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ДобавитьФайл(Корень, ФайлИнфо)
	
	ПараметрыЗаполнения = Новый Структура;
	ПараметрыЗаполнения.Вставить("Наименование", ФайлИнфо.Наименование);
	ПараметрыЗаполнения.Вставить("Ссылка", ФайлИнфо.Ссылка);
	ПараметрыЗаполнения.Вставить("Размер", ФайлИнфо.Размер);
	ПараметрыЗаполнения.Вставить("Расширение", ФайлИнфо.Расширение);
	СтрокаФайл = ТаблицаФайловДобавитьСтроку(Корень, "Файл", ПараметрыЗаполнения);
	
КонецПроцедуры

&НаСервере
Функция ТаблицаФайловДобавитьСтроку(Корень, ВидСтроки, ПараметрыЗаполнения)
	
	ТаблицаФайловСтрока = Корень.ПолучитьЭлементы().Добавить();
	ТаблицаФайловСтрока.ЭтоДокумент = Ложь;
	ТаблицаФайловСтрока.ЭтоФайл = Ложь;
	ТаблицаФайловСтрока.ЭтоПодпись = Ложь;
	
	Если ВидСтроки = "Комплект" Тогда
		ТаблицаФайловСтрока.Наименование = ПараметрыЗаполнения.Наименование;
		ТаблицаФайловСтрока.Ссылка = ПараметрыЗаполнения.Ссылка;
		ТаблицаФайловСтрока.ИндексКартинки = 2;
		ТаблицаФайловСтрока.Размер = 0;
		ТаблицаФайловСтрока.ЭтоДокумент = Истина;
	ИначеЕсли ВидСтроки = "Документ" Тогда
		ТаблицаФайловСтрока.Наименование = ПараметрыЗаполнения.Наименование;
		ТаблицаФайловСтрока.Ссылка = ПараметрыЗаполнения.Ссылка;
		ТаблицаФайловСтрока.ИндексКартинки = 0;
		ТаблицаФайловСтрока.Размер = 0;
		ТаблицаФайловСтрока.ЭтоДокумент = Истина;
	ИначеЕсли ВидСтроки = "Файл" Тогда
		ТаблицаФайловСтрока.Наименование = ПараметрыЗаполнения.Наименование;
		ТаблицаФайловСтрока.Ссылка = ПараметрыЗаполнения.Ссылка;
		ТаблицаФайловСтрока.ИндексКартинки = ФайловыеФункцииКлиентСервер.ПолучитьИндексПиктограммыФайла(ПараметрыЗаполнения.Расширение);
		ТаблицаФайловСтрока.Размер = ПараметрыЗаполнения.Размер;
		ТаблицаФайловСтрока.ЭтоФайл = Истина;
	ИначеЕсли ВидСтроки = "Подпись" Тогда
		ТаблицаФайловСтрока.Наименование = ПараметрыЗаполнения.Наименование;
		ТаблицаФайловСтрока.ИмяФайла = ПараметрыЗаполнения.ИмяФайла;
		ТаблицаФайловСтрока.Ссылка = Неопределено;
		ТаблицаФайловСтрока.ИндексКартинки = 4; 
		ТаблицаФайловСтрока.Подпись = ПараметрыЗаполнения.Подпись;
		ТаблицаФайловСтрока.Размер = ПараметрыЗаполнения.Размер;
		ТаблицаФайловСтрока.ЭтоФайл = Истина;
		ТаблицаФайловСтрока.ЭтоПодпись = Истина;
	КонецЕсли;
	
	ПересчитатьРазмерКб(ТаблицаФайловСтрока);
	
	Возврат ТаблицаФайловСтрока;
	
КонецФункции

&НаСервере
Процедура ЗаполнитьПолучателей(Объекты = Неопределено)
	
	Для каждого ЭлементДерева Из ТаблицаФайлов.ПолучитьЭлементы() Цикл
		ДобавитьПолучателейИзВложения(ЭлементДерева);
	КонецЦикла;
	
	Если ТипЗнч(Объекты) = Тип("Массив") Тогда
		Для каждого Заявитель Из Объекты Цикл
			Если ТипЗнч(Заявитель) = Тип("СправочникСсылка.Заявители") Тогда
				ДобавитьПолучателя(Заявитель);
			КонецЕсли;
		КонецЦикла;	
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ДобавитьПолучателейИзВложения(ЭлементДерева)
	
	Если ЭлементДерева.ЭтоДокумент Тогда
		
		Заявитель = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ЭлементДерева.Ссылка, "Заявитель");
		Если ЗначениеЗаполнено(Заявитель) Тогда
			ДобавитьПолучателя(Заявитель);
		КонецЕсли;
		
	КонецЕсли;
	
КонецФункции

&НаСервере
Процедура ДобавитьПолучателя(Получатель)
	
	Если Не ЗначениеЗаполнено(Получатель) Тогда
		Возврат;
	КонецЕсли;
	
	ПредставлениеПочтовогоАдреса = ПолучитьАдресДляОтправкиЛегкойПочтой(Получатель);
	
	СтрокаДанных = Получатели.Добавить();
	СтрокаДанных.ТипАдреса = НСтр("ru = 'Кому:'");
	СтрокаДанных.Адрес = ПредставлениеПочтовогоАдреса;
	
КонецПроцедуры

&НаСервере
Функция ПолучитьАдресДляОтправкиЛегкойПочтой(Получатель)
	
	Если ТипЗнч(Получатель) = Тип("СправочникСсылка.Заявители") Тогда
		ТекстЗапроса =
			"ВЫБРАТЬ
			|	Заявители.АдресЭлектроннойПочты КАК ПочтовыйАдрес,
			|	ПРЕДСТАВЛЕНИЕ(Заявители.Ссылка) КАК Представление
			|ИЗ
			|	Справочник.Заявители КАК Заявители
			|ГДЕ
			|	Заявители.Ссылка = &Ссылка";
		
	ИначеЕсли ТипЗнч(Получатель) = Тип("СправочникСсылка.Пользователи") Тогда
		ТекстЗапроса =
			"ВЫБРАТЬ
			|	КонтактнаяИнформация.АдресЭП КАК ПочтовыйАдрес,
			|	ПРЕДСТАВЛЕНИЕ(КонтактнаяИнформация.Ссылка) КАК Представление
			|ИЗ
			|	Справочник.Пользователи.КонтактнаяИнформация КАК КонтактнаяИнформация
			|ГДЕ
			|	КонтактнаяИнформация.Ссылка = &Ссылка
			|	И КонтактнаяИнформация.Тип = ЗНАЧЕНИЕ(Перечисление.ТипыКонтактнойИнформации.АдресЭлектроннойПочты)
			|	И КонтактнаяИнформация.Вид = ЗНАЧЕНИЕ(Справочник.ВидыКонтактнойИнформации.EmailПользователя)";
		
	Иначе
		ВызватьИсключение НСтр("ru = 'В функцию ПолучитьАдресДляОтправкиЛегкойПочтой передан некорректный параметр'");
	КонецЕсли;
	
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("Ссылка", Получатель);
	РезультатЗапроса = Запрос.Выполнить();
	Если РезультатЗапроса.Пустой() Тогда
		Возврат "";
	КонецЕсли;
	
	СтрокаРезультата = РезультатЗапроса.Выгрузить()[0];
	Если Не ЗначениеЗаполнено(СтрокаРезультата.ПочтовыйАдрес) Тогда
		Возврат "";
	КонецЕсли;	
	
	Результат = РаботаСоСтроками.ПолучитьПредставлениеАдресаЭлектроннойПочты(
		Строка(СтрокаРезультата.Представление),
		СокрЛП(СтрокаРезультата.ПочтовыйАдрес));
	
	Возврат Результат;
	
КонецФункции

&НаСервере
Функция ДобавитьОписаниеВложения(ЭлементДерева, Контекст)
	
	ПредставлениеОбъекта = ПолучитьПредставлениеОбъекта(ЭлементДерева.Ссылка);
	Если ЭлементДерева.ЭтоДокумент Тогда
		
		Контекст.Тема = ПредставлениеОбъекта;
		
		ПараметрыДоговора = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ЭлементДерева.Ссылка, 
			"СуммаДокумента, ДатаНачалаДействия, ДатаОкончанияДействия");
		
		Если ЗначениеЗаполнено(ПараметрыДоговора.СуммаДокумента) Тогда
			
			ДобавитьЗначениеКСтрокеЧерезРазделитель(
				Контекст.СодержаниеДокументов,
				Символы.ПС + Символы.ПС,
				СтрШаблон(НСтр("ru ='Сумма: %1 руб'"), ПараметрыДоговора.СуммаДокумента));
			
		КонецЕсли;	
			
		Если ЗначениеЗаполнено(ПараметрыДоговора.ДатаНачалаДействия) 
			Или ЗначениеЗаполнено(ПараметрыДоговора.ДатаОкончанияДействия) Тогда
			
			СтрокаСрок = НСтр("ru ='Срок: '");
			
			Если ЗначениеЗаполнено(ПараметрыДоговора.ДатаНачалаДействия) Тогда
				
				СтрокаСрок = СтрокаСрок 
					+ СтрШаблон(НСтр("ru ='с %1 '"), Формат(ПараметрыДоговора.ДатаНачалаДействия, "ДФ=dd.MM.yyyy"));
				
			КонецЕсли;	
			
			Если ЗначениеЗаполнено(ПараметрыДоговора.ДатаОкончанияДействия) Тогда
				
				СтрокаСрок = СтрокаСрок 
					+ СтрШаблон(НСтр("ru ='по %1 '"), Формат(ПараметрыДоговора.ДатаОкончанияДействия, "ДФ=dd.MM.yyyy"));
				
			КонецЕсли;	
			
			ДобавитьЗначениеКСтрокеЧерезРазделитель(
				Контекст.СодержаниеДокументов,
				Символы.ПС + Символы.ПС,
				СтрокаСрок);
			
		КонецЕсли;	
		
		Контекст.КоличествоОснований = Контекст.КоличествоОснований + 1;
		
	ИначеЕсли ЭлементДерева.ЭтоФайл Тогда
		
		Контекст.Тема = ПредставлениеОбъекта;
		ДобавитьЗначениеКСтрокеЧерезРазделитель(
			Контекст.ТекстОснований,
			Символы.ПС + Символы.ПС,
			ПредставлениеОбъекта);
		
		Контекст.КоличествоОснований = Контекст.КоличествоОснований + 1;
		
	КонецЕсли;
	
КонецФункции

&НаСервере
Функция ПолучитьПредставлениеОбъекта(Объект)
	
	Возврат Строка(Объект);
	
КонецФункции

&НаСервере
Процедура ПересчитатьРазмерКб(ТаблицаФайловСтрока)
	
	Если ТаблицаФайловСтрока.Размер = 0 Тогда
		ТаблицаФайловСтрока.РазмерКб = 0;
	Иначе
		ТаблицаФайловСтрока.РазмерКб = Макс(1, Окр(ТаблицаФайловСтрока.Размер / 1024));
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПересчитатьРазмерВложений()
	
	Контекст = Новый Структура("ИтогоРазмерКб", 0);
	ОбойтиДерево(ТаблицаФайлов, Контекст, "ПересчетРазмераВложений");
	ИтогоРазмерКб = Контекст.ИтогоРазмерКб;
	
КонецПроцедуры

&НаСервере
Функция ПересчетРазмераВложений(ЭлементДерева, Контекст)
	
	ПересчитатьРазмерКб(ЭлементДерева);
	Контекст.ИтогоРазмерКб = Контекст.ИтогоРазмерКб + ЭлементДерева.РазмерКб;
	
КонецФункции

&НаСервере
Процедура ОбойтиДерево(Корень, Контекст, ИмяПроцедуры)
	
	Для каждого ЭлементДерева Из Корень.ПолучитьЭлементы() Цикл
		Результат = Вычислить(ИмяПроцедуры + "(ЭлементДерева, Контекст)");
		ОбойтиДерево(ЭлементДерева, Контекст, ИмяПроцедуры);
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбойтиДеревоНаКлиенте(Корень, Контекст, ИмяПроцедуры)
	
	Для каждого ЭлементДерева Из Корень.ПолучитьЭлементы() Цикл
		Результат = Вычислить(ИмяПроцедуры + "(ЭлементДерева, Контекст)");
		ОбойтиДеревоНаКлиенте(ЭлементДерева, Контекст, ИмяПроцедуры);
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Функция ПолучитьИнформациюОФайлах(Отбор)
	
	ПостроительЗапроса = Новый ПостроительЗапроса;
	ПостроительЗапроса.Текст =
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	Файлы.Ссылка КАК Ссылка,
		|	Файлы.Наименование КАК Наименование,
		|	Файлы.ТекущаяВерсияРазмер КАК Размер,
		|	Файлы.ТекущаяВерсияРасширение КАК Расширение
		|ИЗ
		|	Справочник.Файлы КАК Файлы
		|{ГДЕ
		|	Файлы.ВладелецФайла.*,
		|	Файлы.Ссылка.*,
		|	Файлы.ПометкаУдаления}";
	Для каждого КлючЗначение Из Отбор Цикл
		ПостроительЗапроса.Отбор.Добавить(КлючЗначение.Ключ);
		ПостроительЗапроса.Отбор[КлючЗначение.Ключ].Установить(КлючЗначение.Значение);
	КонецЦикла;
	ПостроительЗапроса.Выполнить();
	Результат = ПостроительЗапроса.Результат.Выгрузить();
	
	Возврат Результат;
	
КонецФункции

&НаКлиенте
Процедура ЗаполнитьПараметрыОтправкиКлиент()
	
	ПараметрыОтправкиПочтовогоСообщения.УстановитьПрофиль(ПараметрыОтправки, Профиль);
	
	КомуСтр = "";
	КопияСтр = "";
	СкрытаяКопияСтр = "";
		
	Для Каждого Строка Из Получатели Цикл
		Если Не ПустаяСтрока(Строка.Адрес) Тогда
			
			Если Строка.ТипАдреса = НСтр("ru = 'Кому:'") Тогда
				ДобавитьЗначениеКСтрокеЧерезРазделитель(КомуСтр, "; ", Строка.Адрес);
			КонецЕсли;		
			
			Если Строка.ТипАдреса = НСтр("ru = 'Копия:'") Тогда
				ДобавитьЗначениеКСтрокеЧерезРазделитель(КопияСтр, "; ", Строка.Адрес);
			КонецЕсли;		
					
			Если Строка.ТипАдреса = НСтр("ru = 'Скрытая копия:'") Тогда		
				ДобавитьЗначениеКСтрокеЧерезРазделитель(СкрытаяКопияСтр, "; ", Строка.Адрес);
			КонецЕсли;		
			
		КонецЕсли;	
	КонецЦикла;	
		
	ПараметрыОтправкиПочтовогоСообщения.УстановитьПолучателей(ПараметрыОтправки, "Кому", КомуСтр);
	ПараметрыОтправкиПочтовогоСообщения.УстановитьПолучателей(ПараметрыОтправки, "Копия", КопияСтр);
	ПараметрыОтправкиПочтовогоСообщения.УстановитьПолучателей(ПараметрыОтправки, "СкрытаяКопия", СкрытаяКопияСтр);
	
	ПараметрыОтправкиПочтовогоСообщения.УстановитьТему(ПараметрыОтправки, Тема);
	ПараметрыОтправкиПочтовогоСообщения.УстановитьТекст(ПараметрыОтправки, Содержание);
	
	ВажностьПисьма = ?(Важность,
		ПредопределенноеЗначение("Перечисление.ВажностьПисем.Высокая"),
		ПредопределенноеЗначение("Перечисление.ВажностьПисем.Обычная"));
	ПараметрыОтправкиПочтовогоСообщения.УстановитьВажность(ПараметрыОтправки, ВажностьПисьма);
	
	ПараметрыОтправкиПочтовогоСообщения.ОчиститьВложения(ПараметрыОтправки);
	Для каждого ВложениеСтрока Из Вложения Цикл
		
		Если ВложениеСтрока.Расположение = "Ссылка" Тогда
			ПараметрыОтправкиПочтовогоСообщения.ДобавитьВложениеФайл(
				ПараметрыОтправки,
				ВложениеСтрока.Ссылка);
		ИначеЕсли ВложениеСтрока.Расположение = "ВременноеХранилище" Тогда
			ПараметрыОтправкиПочтовогоСообщения.ДобавитьВложениеИзВременногоХранилища(
				ПараметрыОтправки,
				ВложениеСтрока.Адрес,
				ВложениеСтрока.ИмяФайла);
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьТекущийЭлементПолучатель()
	
	РежимДобавленияАдресата = Истина;
	Элементы.Получатели.ДобавитьСтроку();
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьВложениеКлиент()
	
	ТекущаяСтрока = Элементы.Вложения.ТекущаяСтрока;
	Если ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли;
	ТекущиеДанные = Элементы.Вложения.ТекущиеДанные;
	
	Если Не РасширениеРаботыСФайламиПодключено() Тогда
		Возврат;
	КонецЕсли;
	Если ЗначениеЗаполнено(ТекущиеДанные.Ссылка) Тогда
		КомандыРаботыСФайламиКлиент.Открыть(
			РаботаСФайламиВызовСервера.ДанныеФайлаДляОткрытия(
				ТекущиеДанные.Ссылка, Неопределено, УникальныйИдентификатор));
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Функция РасширениеРаботыСФайламиПодключено()
	
	Если Не ФайловыеФункцииСлужебныйКлиент.РасширениеРаботыСФайламиПодключено() Тогда
		ПоказатьПредупреждение(, НСтр("ru = 'Не подключено расширение работы с файлами!'"));
		Возврат Ложь;
	КонецЕсли;
	
	Возврат Истина;;
	
КонецФункции

// Формирует список получателей.
Функция СформироватьДанныеВыбораПолучателя(Текст) 
	
	ДанныеВыбора = Новый СписокЗначений;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 20
		|	Пользователи.Ссылка КАК Ссылка,
		|	Пользователи.Наименование КАК Наименование,
		|	Пользователи.АдресЭлектроннойПочты КАК ПочтовыйАдрес
		|ИЗ
		|	Справочник.Пользователи КАК Пользователи
		|ГДЕ
		|	Пользователи.ПометкаУдаления = ЛОЖЬ
		|	И Пользователи.Наименование ПОДОБНО &Текст
		|	И Пользователи.АдресЭлектроннойПочты <> """"
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ ПЕРВЫЕ 20
		|	Пользователи.Ссылка,
		|	Пользователи.Наименование,
		|	Пользователи.АдресЭлектроннойПочты
		|ИЗ
		|	Справочник.Пользователи КАК Пользователи
		|ГДЕ
		|	Пользователи.ПометкаУдаления = ЛОЖЬ
		|	И Пользователи.АдресЭлектроннойПочты ПОДОБНО &Текст
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ ПЕРВЫЕ 20
		|	Заявители.Ссылка,
		|	Заявители.Наименование,
		|	Заявители.АдресЭлектроннойПочты
		|ИЗ
		|	Справочник.Заявители КАК Заявители
		|ГДЕ
		|	Заявители.ПометкаУдаления = ЛОЖЬ
		|	И Заявители.Наименование ПОДОБНО &Текст
		|	И Заявители.АдресЭлектроннойПочты <> """"
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ ПЕРВЫЕ 20
		|	Заявители.Ссылка,
		|	Заявители.Наименование,
		|	Заявители.АдресЭлектроннойПочты
		|ИЗ
		|	Справочник.Заявители КАК Заявители
		|ГДЕ
		|	Заявители.ПометкаУдаления = ЛОЖЬ
		|	И Заявители.АдресЭлектроннойПочты ПОДОБНО &Текст";
		
	Запрос.УстановитьПараметр("Текст", Текст + "%");
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		
		Представление = Выборка.Наименование + " <" + Выборка.ПочтовыйАдрес +  ">"; 
		СтруктураВыбора = Новый Структура("Ссылка, Адрес, Представление", 
			Выборка.Ссылка, Выборка.ПочтовыйАдрес, Представление);
		
		ДанныеВыбора.Добавить(СтруктураВыбора, Представление);
		
	КонецЦикла;
	
	Возврат ДанныеВыбора;
	
КонецФункции

&НаКлиенте
Процедура НастройкаПочты(Команда)

	Обработчик = Новый ОписаниеОповещения("ПослеВопросаОВыбореИнтернетПочты", 
		ЭтотОбъект);
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("РежимНастройкиДляОбычногоПользователя", Истина);
	ПараметрыФормы.Вставить("ЭтоНастройкаДляЗагрузки", Ложь);
	
	ВидПочтовогоКлиента = ПараметрыОтправки.НастройкиПрофилейДляОтправки.Профиль.ВидПочтовогоКлиента;
	ПараметрыФормы.Вставить("ВидПочтовогоКлиента", ВидПочтовогоКлиента);
	
	ПараметрыФормы.Вставить("Профиль", ПараметрыОтправки.НастройкиПрофилейДляОтправки.Профиль.Профиль);
	ПараметрыФормы.Вставить("Данные", ПараметрыОтправки.НастройкиПрофилейДляОтправки.Профиль.Данные);
	
	ОткрытьФорму("Справочник.УчетныеЗаписиЭлектроннойПочты.Форма.НастройкаОтправкиСообщений", 
		ПараметрыФормы,,,,,Обработчик);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеВопросаОВыбореИнтернетПочты(КодВозврата, ПараметрыВыполнения) Экспорт
	
	Если ЛегкаяПочтаКлиент.СохранитьНастройкиПочты(КодВозврата) Тогда
		
		ПараметрыОтправки = ПараметрыОтправкиПочтовогоСообщенияВызовСервера.Создать();
		ДоступныеПрофили = ПараметрыОтправкиПочтовогоСообщения.ПолучитьСписокДоступныхПрофилей(ПараметрыОтправки);
		
		// Установим профиль.
		Профиль = ПараметрыОтправкиПочтовогоСообщения.ПолучитьПрофиль(ПараметрыОтправки);
		Если Параметры.Свойство("ВебКлиент") И Параметры.ВебКлиент = Истина И ТипЗнч(Профиль) = Тип("Строка") Тогда
			Профиль = Неопределено;
		КонецЕсли;
		
	КонецЕсли;	
	
КонецПроцедуры	

#КонецОбласти
