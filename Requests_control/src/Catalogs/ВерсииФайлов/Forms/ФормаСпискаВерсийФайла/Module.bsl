&НаКлиенте
Перем Ссылка1;

&НаКлиенте
Перем Ссылка2;


////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Элементы.ПоказатьВерсииВВидеДерева.Пометка = Ложь;
	Элементы.ПоказатьВерсииВВидеСписка.Пометка = Истина;
	
	ВидимостьКомандыСравнить = 
		Не ОбщегоНазначенияКлиентСервер.ЭтоLinuxКлиент() И Не ОбщегоНазначенияКлиентСервер.ЭтоВебКлиент();
	Элементы.ФормаСравнить.Видимость = ВидимостьКомандыСравнить;
	Элементы.КонтекстноеМенюСписокСравнить.Видимость = ВидимостьКомандыСравнить;
	
	УникальныйИдентификаторКарточкиФайла = Параметры.УникальныйИдентификаторКарточкиФайла;
	
	НастройкиФормы = ОбщегоНазначения.ХранилищеСистемныхНастроекЗагрузить(ИмяФормы + "/ТекущиеДанные", "");
	Если НастройкиФормы = Неопределено Тогда
		ЗаполнитьДеревоВерсий();
	КонецЕсли;
	
	Элементы.Автор.Видимость = ПолучитьФункциональнуюОпцию("ПоказыватьПользователей");
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ОБЩЕГО НАЗНАЧЕНИЯ

&НаСервере
Функция СменитьАктивнуюВерсиюФайла(Версия, СтрокаОшибки = "")
	
	СтрокаОшибки = "";
	РаботаСФайламиПереопределяемый.ПриПопыткеЗанятьФайл(Версия.Владелец, СтрокаОшибки);
	Если Не ПустаяСтрока(СтрокаОшибки) Тогда
		Возврат Ложь;
	КонецЕсли;
	
	ФайлОбъект = Версия.Владелец.ПолучитьОбъект();
	ЗаблокироватьДанныеДляРедактирования(ФайлОбъект.Ссылка, , УникальныйИдентификаторКарточкиФайла);
	ФайлОбъект.ТекущаяВерсия = Версия;
	ФайлОбъект.ТекстХранилище = Версия.ТекстХранилище;
	ФайлОбъект.Записать();
	РазблокироватьДанныеДляРедактирования(ФайлОбъект.Ссылка, УникальныйИдентификаторКарточкиФайла);
	
	ВерсияОбъект = Версия.ПолучитьОбъект();
	ЗаблокироватьДанныеДляРедактирования(Версия, , УникальныйИдентификаторКарточкиФайла);
	ВерсияОбъект.Записать();
	РазблокироватьДанныеДляРедактирования(Версия, УникальныйИдентификаторКарточкиФайла);
	
	Возврат Истина;
	
КонецФункции

&НаСервере
Процедура ЗаполнитьДеревоВерсий()
	
	Если Не ПолныйПоказСпискаВерсий Тогда
		ЗаполнитьДеревоВерсийУпрощенныйВариант();
	Иначе
		ЗаполнитьДеревоВерсийПолныйВариант();
	КонецЕсли;	
	
КонецПроцедуры	

// Заполняет дерево версий в упрощенном варианте - просто по хронологии - линейный список
&НаСервере
Процедура ЗаполнитьДеревоВерсийУпрощенныйВариант()
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ВерсииФайлов.Код КАК Код,
	|	ВерсииФайлов.Размер КАК Размер,
	|	ВерсииФайлов.Комментарий КАК Комментарий,
	|	ВерсииФайлов.Автор КАК Автор,
	|	ВерсииФайлов.ДатаСоздания КАК ДатаСоздания,
	|	ВерсииФайлов.ПолноеНаименование КАК ПолноеНаименование,
	|	ВерсииФайлов.РодительскаяВерсия КАК РодительскаяВерсия,
	|	ВЫБОР
	|		КОГДА ВерсииФайлов.ПометкаУдаления = ИСТИНА
	|			ТОГДА 1
	|		ИНАЧЕ ВерсииФайлов.ИндексКартинки
	|	КОНЕЦ КАК ИндексКартинки,
	|	ВерсииФайлов.ПометкаУдаления КАК ПометкаУдаления,
	|	ВерсииФайлов.Владелец КАК Владелец,
	|	ВерсииФайлов.Ссылка КАК Ссылка,
	|	ВЫБОР
	|		КОГДА ВерсииФайлов.Владелец.ТекущаяВерсия = ВерсииФайлов.Ссылка
	|			ТОГДА ИСТИНА
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ КАК ЭтоТекущая,
	|	ВерсииФайлов.Расширение КАК Расширение,
	|	ВерсииФайлов.НомерВерсии КАК НомерВерсии,
	|	ВерсииФайлов.ФайлУдален КАК ФайлУдален
	|ИЗ
	|	Справочник.ВерсииФайлов КАК ВерсииФайлов
	|ГДЕ
	|	ВерсииФайлов.Владелец = &Владелец
	|
	|УПОРЯДОЧИТЬ ПО
	|	ДатаСоздания УБЫВ");
	
	Запрос.УстановитьПараметр("Владелец", Параметры.Файл);
	Данные = Запрос.Выполнить().Выгрузить();
	
	Дерево = РеквизитФормыВЗначение("ДеревоВерсий");
	Дерево.Строки.Очистить();
	
	Для Каждого Строка Из Данные Цикл
		Ветвь = Дерево.Строки.Добавить();
		ЗаполнитьЗначенияСвойств(Ветвь, Строка);
	КонецЦикла;	
	
	ЗначениеВРеквизитФормы(Дерево, "ДеревоВерсий");
	
КонецПроцедуры	

// Заполняет дерево версий в полном варианте - дерево версий
&НаСервере
Процедура ЗаполнитьДеревоВерсийПолныйВариант()
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ВерсииФайлов.Код КАК Код,
	|	ВерсииФайлов.Размер КАК Размер,
	|	ВерсииФайлов.Комментарий КАК Комментарий,
	|	ВерсииФайлов.Автор КАК Автор,
	|	ВерсииФайлов.ДатаСоздания КАК ДатаСоздания,
	|	ВерсииФайлов.ПолноеНаименование КАК ПолноеНаименование,
	|	ВерсииФайлов.РодительскаяВерсия КАК РодительскаяВерсия,
	|	ВЫБОР
	|		КОГДА ВерсииФайлов.ПометкаУдаления = ИСТИНА
	|			ТОГДА 1
	|		ИНАЧЕ ВерсииФайлов.ИндексКартинки
	|	КОНЕЦ КАК ИндексКартинки,
	|	ВерсииФайлов.ПометкаУдаления КАК ПометкаУдаления,
	|	ВерсииФайлов.Владелец КАК Владелец,
	|	ВерсииФайлов.Ссылка КАК Ссылка,
	|	ВЫБОР
	|		КОГДА ВерсииФайлов.Владелец.ТекущаяВерсия = ВерсииФайлов.Ссылка
	|			ТОГДА ИСТИНА
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ КАК ЭтоТекущая,
	|	ВерсииФайлов.Расширение КАК Расширение,
	|	ВерсииФайлов.НомерВерсии КАК НомерВерсии,
	|	ВерсииФайлов.ФайлУдален КАК ФайлУдален
	|ИЗ
	|	Справочник.ВерсииФайлов КАК ВерсииФайлов
	|ГДЕ
	|	ВерсииФайлов.Владелец = &Владелец");
	
	Запрос.УстановитьПараметр("Владелец", Параметры.Файл);
	Данные = Запрос.Выполнить().Выгрузить();
	
	Дерево = РеквизитФормыВЗначение("ДеревоВерсий");
	Дерево.Строки.Очистить();
	
	ТекущиеВетви = Новый Массив;
	ТекущиеВетви.Добавить(Неопределено);
	 
	Пока ТекущиеВетви.Количество() <> 0 Цикл
		
		Индекс = ТекущиеВетви.Количество() - 1;
		ТекущаяВетвь = ТекущиеВетви[Индекс];
		ТекущиеВетви.Удалить(Индекс);
		
		ДобавитьПредыдущуюВерсию(ТекущаяВетвь, Дерево, Данные, ТекущиеВетви);
		 
	КонецЦикла; 		 
	
	ЗначениеВРеквизитФормы(Дерево, "ДеревоВерсий");
	
КонецПроцедуры	

&НаСервере
Процедура ДобавитьПредыдущуюВерсию(ТекущаяВетвь, Дерево, Данные, ТекущиеВетви)
	
	НайденнаяСтрока = Неопределено;
	
	Если ТекущаяВетвь = Неопределено Тогда
		
		Для Каждого Строка Из Данные Цикл
			Если Строка.ЭтоТекущая Тогда
				НайденнаяСтрока = Строка;
				Прервать;
			КонецЕсли;	
		КонецЦикла;		
		
	Иначе
		
		НайденнаяСтрока = Данные.Найти(ТекущаяВетвь.РодительскаяВерсия, "Ссылка");
		
	КонецЕсли;	
	
	Если НайденнаяСтрока <> Неопределено Тогда 
		Ветвь = Дерево.Строки.Добавить();
		ЗаполнитьЗначенияСвойств(Ветвь, НайденнаяСтрока);
		Данные.Удалить(НайденнаяСтрока);
		
		ДобавитьПодчиненныеВерсии(Ветвь, Данные);
		
		ТекущиеВетви.Добавить(Ветвь);
		
	КонецЕсли;			
	
КонецПроцедуры

&НаСервере
Процедура ДобавитьПодчиненныеВерсии(Ветвь, Данные)
	
	Отбор = Новый Структура();
	Отбор.Вставить("РодительскаяВерсия", Ветвь.Ссылка);
	
	НайденныеСтроки = Данные.НайтиСтроки(Отбор);
	
	Для Каждого Строка из НайденныеСтроки Цикл
		ЗаполнитьЗначенияСвойств(Ветвь.Строки.Добавить(), Строка);
	КонецЦикла;
	
	Для Каждого Веточка из Ветвь.Строки Цикл
		ДобавитьПодчиненныеВерсии(Веточка, Данные);
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ПометитьНаУдалениеСнятьПометкуНаСервере(Версия)
	
	Пометка = Не Версия.ПометкаУдаления;
	
	ВерсияОбъект = Версия.ПолучитьОбъект();
	ВерсияОбъект.Заблокировать();
	ВерсияОбъект.УстановитьПометкуУдаления(Пометка);
	
КонецПроцедуры	

&НаКлиенте
Процедура ПометитьНаУдалениеСнятьПометку()
	
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	Пометка = ОбщегоНазначенияДокументооборотВызовСервера.ЗначениеРеквизитаОбъекта(ТекущиеДанные.Ссылка, "ПометкаУдаления");
	Если Пометка Тогда 
		ТекстВопроса = СтрШаблон(
			НСтр("ru = 'Cнять с ""%1"" пометку на удаление?'"),
			Строка(ТекущиеДанные.Ссылка));
	Иначе
		ТекстВопроса = СтрШаблон(
			НСтр("ru = 'Пометить ""%1"" на удаление?'"),
			Строка(ТекущиеДанные.Ссылка));
	КонецЕсли;	
	
	ПараметрыОбработчика = Новый Структура;
	ПараметрыОбработчика.Вставить("ТекущиеДанные", ТекущиеДанные);
	ПараметрыОбработчика.Вставить("Пометка", Пометка);
	Обработчик = Новый ОписаниеОповещения("ПометитьНаУдалениеСнятьПометкуЗавершение", ЭтотОбъект, ПараметрыОбработчика);
	ПоказатьВопрос(Обработчик, ТекстВопроса, РежимДиалогаВопрос.ДаНет, , КодВозвратаДиалога.Да);
	
КонецПроцедуры	

&НаКлиенте
Процедура ПометитьНаУдалениеСнятьПометкуЗавершение(Ответ, ПараметрыВыполнения) Экспорт
	
	Если Ответ <> КодВозвратаДиалога.Да Тогда 
		Возврат;
	КонецЕсли;
	
	ПометитьНаУдалениеСнятьПометкуНаСервере(ПараметрыВыполнения.ТекущиеДанные.Ссылка);
	
	Если Не ПараметрыВыполнения.Пометка Тогда
		ПараметрыВыполнения.ТекущиеДанные.ИндексКартинки = 1;
	Иначе
		ПараметрыВыполнения.ТекущиеДанные.ИндексКартинки = 
			ОбщегоНазначенияДокументооборотВызовСервера.ЗначениеРеквизитаОбъекта(ПараметрыВыполнения.ТекущиеДанные.Ссылка, "ИндексКартинки");
	КонецЕсли;
		
КонецПроцедуры
////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ФОРМЫ

&НаКлиенте
Процедура СделатьАктивнойВыполнить()
	
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;	
	
	Если ТекущиеДанные.ФайлУдален Тогда
		ПоказатьПредупреждение(, НСтр("ru = 'Нельзя сделать активной очищенную версию.'"));
		Возврат;
	КонецЕсли;	
	
	ДанныеФайла = РаботаСФайламиВызовСервера.ДанныеФайла(Неопределено, ТекущиеДанные.Ссылка);
	Если ЗначениеЗаполнено(ДанныеФайла.Редактирует) Тогда
		ПоказатьПредупреждение(, НСтр("ru = 'Смена активной версии разрешена только для незанятых файлов!'"));
		Возврат;
	КонецЕсли;	
	
	СтрокаОшибки = "";
	Если Не СменитьАктивнуюВерсиюФайла(ТекущиеДанные.Ссылка, СтрокаОшибки) Тогда 
		ПоказатьПредупреждение(, СтрокаОшибки);
		Возврат;
	КонецЕсли;	
	
	ЗаполнитьДеревоВерсий();
	Оповестить("АктивнаяВерсияИзменена", Параметры.Файл);
	
КонецПроцедуры

&НаКлиенте
Функция ОбойтиВсеУзлыДерева(Элементы, ТекущаяВерсия)
	
	Для Каждого Версия Из Элементы Цикл
		
		Если Версия.Ссылка = ТекущаяВерсия Тогда
			Идентификатор = Версия.ПолучитьИдентификатор();
			Возврат Идентификатор;
		КонецЕсли;	
		
		КодВозврата = ОбойтиВсеУзлыДерева(Версия.ПолучитьЭлементы(), ТекущаяВерсия);
		Если КодВозврата <> -1 Тогда
			Возврат КодВозврата;
		КонецЕсли;	
	КонецЦикла;	
	
	Возврат -1;
КонецФункции

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ЗаконченоРедактирование" Или ИмяСобытия = "ВерсияСохранена" 
		ИЛИ ИмяСобытия = "ВерсияВосстановлена" Тогда
		
		Если Параметры.Файл = Параметр И Элементы.Список.ТекущиеДанные <> Неопределено Тогда
			
			ТекущаяВерсия = Элементы.Список.ТекущиеДанные.Ссылка;
			ЗаполнитьДеревоВерсий();
			
			КодВозврата = ОбойтиВсеУзлыДерева(ДеревоВерсий.ПолучитьЭлементы(), ТекущаяВерсия);
			Если КодВозврата <> -1 Тогда
				Элементы.Список.ТекущаяСтрока = КодВозврата;
			КонецЕсли;	
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	
	РаботаСФайламиКлиент.Открыть(
		РаботаСФайламиВызовСервера.ДанныеФайлаДляОткрытия(Неопределено, ТекущиеДанные.Ссылка, УникальныйИдентификатор),
		УникальныйИдентификатор);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьКарточку(Команда)
	
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено Тогда 
		
		Версия = ТекущиеДанные.Ссылка;
		
		ПараметрыОткрытияФормы = Новый Структура("Ключ", Версия);
		ОткрытьФорму("Справочник.ВерсииФайлов.ФормаОбъекта", ПараметрыОткрытияФормы);
		
	КонецЕсли;		
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПередУдалением(Элемент, Отказ)
	
	Отказ = Истина;
	ПометитьНаУдалениеСнятьПометку();
		
КонецПроцедуры

&НаКлиенте
Процедура ПометитьНаУдаление(Команда)
	
	ПометитьНаУдалениеСнятьПометку();
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПередНачаломИзменения(Элемент, Отказ)
	
	Отказ = Истина;
	
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено Тогда 
		
		Версия = ТекущиеДанные.Ссылка;
		
		ПараметрыОткрытияФормы = Новый Структура("Ключ", Версия);
		ОткрытьФорму("Справочник.ВерсииФайлов.ФормаОбъекта", ПараметрыОткрытияФормы);
		
	КонецЕсли;
	
КонецПроцедуры

// Сравнить 2 выбранные версии. 
&НаКлиенте
Процедура Сравнить(Команда)
	
	ЧислоВыделенныхСтрок = Элементы.Список.ВыделенныеСтроки.Количество();
	
	Если ЧислоВыделенныхСтрок = 2 ИЛИ ЧислоВыделенныхСтрок = 1 Тогда
		
		#Если НЕ ВебКлиент Тогда	
			
			Если ЧислоВыделенныхСтрок = 2 Тогда
				Ссылка1 = ДеревоВерсий.НайтиПоИдентификатору(Элементы.Список.ВыделенныеСтроки[0]).Ссылка;
				Ссылка2 = ДеревоВерсий.НайтиПоИдентификатору(Элементы.Список.ВыделенныеСтроки[1]).Ссылка;
			ИначеЕсли ЧислоВыделенныхСтрок = 1 Тогда
				
				Ссылка1 = Элементы.Список.ТекущиеДанные.Ссылка;
				Ссылка2 = Элементы.Список.ТекущиеДанные.РодительскаяВерсия;
				
			КонецЕсли;
			
			СпособСравненияВерсийФайлов = Неопределено;
			Расширение = НРег(Элементы.Список.ТекущиеДанные.Расширение);
			
			РасширениеПоддерживается = (Расширение = "txt" ИЛИ Расширение = "doc" ИЛИ Расширение = "docx" ИЛИ Расширение = "rtf" ИЛИ Расширение = "htm" ИЛИ Расширение = "html" ИЛИ Расширение = "odt");
			
			Если Не РасширениеПоддерживается Тогда
				ПоказатьПредупреждение(, НСтр("ru = 'Сравнение версий поддерживается только для файлов следующих типов: 
				|   Текстовый документ (.txt)
				|   Документ формата RTF (.rtf) 
				|   Документ Microsoft Word (.doc, .docx) 
				|   Документ HTML (.html .htm) 
				|   Текстовый документ OpenDocument (.odt)'"));
				Возврат;
			КонецЕсли;
			
			Если СтандартныеПодсистемыКлиентПовтИсп.ПараметрыРаботыКлиента().ЭтоБазоваяВерсияКонфигурации Тогда
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Данная операция не поддерживается в базовой версии.'"));
				Возврат;
			КонецЕсли;
			
			Если Расширение = "odt" Тогда
				СпособСравненияВерсийФайлов = "OpenOfficeOrgWriter";
			ИначеЕсли Расширение = "htm" ИЛИ Расширение = "html" Тогда
				СпособСравненияВерсийФайлов = "MicrosoftOfficeWord";
			ИначеЕсли СпособСравненияВерсийФайлов = Неопределено Тогда
				СпособСравненияВерсийФайлов = ФайловыеФункцииСлужебныйКлиентСервер.ПерсональныеНастройкиРаботыСФайлами().СпособСравненияВерсийФайлов;
				Если СпособСравненияВерсийФайлов = Неопределено Тогда // первый вызов - еще не инициализирована настройка
					ПараметрыФормы = Новый Структура;
					ОткрытьФорму("Справочник.ВерсииФайлов.Форма.ФормаВыбораСпособаСравненияВерсий", ПараметрыФормы, ЭтаФорма);
					Возврат;
				КонецЕсли;
			КонецЕсли;
			
			ПродолжитьСравнениеВерсий(СпособСравненияВерсийФайлов);
		#Иначе
			ПоказатьПредупреждение(, НСтр("ru = 'Сравнение версий в веб-клиенте не поддерживается!'"));
		#КонецЕсли

	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	ЧислоВыделенныхСтрок = Элементы.Список.ВыделенныеСтроки.Количество();
	
	КомандаСравненияДоступна = Ложь;
	
	Если ЧислоВыделенныхСтрок = 2 Тогда
		КомандаСравненияДоступна = Истина;
	ИначеЕсли ЧислоВыделенныхСтрок = 1 Тогда
		
		Если Не Элементы.Список.ТекущиеДанные.РодительскаяВерсия.Пустая() Тогда
			КомандаСравненияДоступна = Истина;		
		Иначе
			КомандаСравненияДоступна = Ложь;
		КонецЕсли;
			
	Иначе
		КомандаСравненияДоступна = Ложь;
	КонецЕсли;
	

	Если КомандаСравненияДоступна = Истина Тогда
		Элементы.ОсновнаяКоманднаяПанель.ПодчиненныеЭлементы.ФормаСравнить.Доступность = Истина;
		Элементы.СписокКонтекстноеМеню.ПодчиненныеЭлементы.КонтекстноеМенюСписокСравнить.Доступность = Истина;
	Иначе
		Элементы.ОсновнаяКоманднаяПанель.ПодчиненныеЭлементы.ФормаСравнить.Доступность = Ложь;
		Элементы.СписокКонтекстноеМеню.ПодчиненныеЭлементы.КонтекстноеМенюСписокСравнить.Доступность = Ложь;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	Если ВРег(ИсточникВыбора.ИмяФормы) = ВРег("Справочник.ВерсииФайлов.Форма.ФормаВыбораСпособаСравненияВерсий") Тогда
		Если ВыбранноеЗначение <> КодВозвратаДиалога.ОК Тогда
			Возврат;
		КонецЕсли;
		СпособСравненияВерсийФайлов = ФайловыеФункцииСлужебныйКлиентСервер.ПерсональныеНастройкиРаботыСФайлами().СпособСравненияВерсийФайлов;
		ПродолжитьСравнениеВерсий(СпособСравненияВерсийФайлов);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьВерсию(Команда)
	
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда 
		Возврат;
	КонецЕсли;	
	
	РаботаСФайламиКлиент.Открыть(
		РаботаСФайламиВызовСервера.ДанныеФайлаДляОткрытия(Неопределено, ТекущиеДанные.Ссылка, УникальныйИдентификатор),
		УникальныйИдентификатор);
	
КонецПроцедуры

&НаКлиенте
Процедура СохранитьКак(Команда)
	
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда 
		Возврат;
	КонецЕсли;	
	
	ДанныеФайла = РаботаСФайламиВызовСервера.ДанныеФайлаДляСохранения(
		Неопределено, ТекущиеДанные.Ссылка, УникальныйИдентификатор);
	КомандыРаботыСФайламиКлиент.СохранитьКак(ДанныеФайла, УникальныйИдентификатор);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	Отказ = Истина;
КонецПроцедуры

&НаКлиенте
Процедура ПродолжитьСравнениеВерсий(СпособСравненияВерсийФайлов)
	#Если НЕ ВебКлиент Тогда
		
		Если СпособСравненияВерсийФайлов = Неопределено Тогда
			Возврат;
		КонецЕсли;
		
		ДанныеФайла1 = РаботаСФайламиВызовСервера.ДанныеФайлаДляОткрытия(Неопределено, Ссылка1, УникальныйИдентификатор);
		ДанныеФайла2 = РаботаСФайламиВызовСервера.ДанныеФайлаДляОткрытия(Неопределено, Ссылка2, УникальныйИдентификатор);
		
		ТекстСостояния = СтрШаблон(
			НСтр("ru = 'Выполняется сравнение версий файла ""%1""...'"), ДанныеФайла1.Ссылка);
		Состояние(ТекстСостояния);
		
		ПолноеИмяФайла1 = "";
		ПолноеИмяФайла2 = "";
		
		ПараметрыВыполнения = Новый Структура("ДанныеФайла1, ДанныеФайла2, СпособСравненияВерсийФайлов, ПолноеИмяФайла1, ПолноеИмяФайла2", 
			ДанныеФайла1, ДанныеФайла2, СпособСравненияВерсийФайлов, ПолноеИмяФайла1, ПолноеИмяФайла2);
		Обработчик = Новый ОписаниеОповещения("ПослеПолучитьФайлВерсииВРабочийКаталог1", ЭтотОбъект, ПараметрыВыполнения);
		РаботаСФайламиКлиент.ПолучитьФайлВерсииВРабочийКаталог(Обработчик, 
			ПараметрыВыполнения.ДанныеФайла1, ПараметрыВыполнения.ПолноеИмяФайла1, УникальныйИдентификатор);
		
	#КонецЕсли
КонецПроцедуры

// Продолжение процедуры (см. выше).
&НаКлиенте
Процедура ПослеПолучитьФайлВерсииВРабочийКаталог1(Результат, ПараметрыВыполнения) Экспорт
	
	Если Результат.ФайлПолучен Тогда
		ПараметрыВыполнения.ПолноеИмяФайла1 = Результат.ПолноеИмяФайла;
		Обработчик = Новый ОписаниеОповещения("ПослеПолучитьФайлВерсииВРабочийКаталог2", ЭтотОбъект, ПараметрыВыполнения);
		РаботаСФайламиКлиент.ПолучитьФайлВерсииВРабочийКаталог(Обработчик, 
			ПараметрыВыполнения.ДанныеФайла2, ПараметрыВыполнения.ПолноеИмяФайла2, УникальныйИдентификатор);
	КонецЕсли;
	
КонецПроцедуры

// Продолжение процедуры (см. выше).
&НаКлиенте
Процедура ПослеПолучитьФайлВерсииВРабочийКаталог2(Результат, ПараметрыВыполнения) Экспорт
	
	Если Результат.ФайлПолучен Тогда
		
		ПараметрыВыполнения.ПолноеИмяФайла2 = Результат.ПолноеИмяФайла;
		
		ПутьКФайлу1 = "";
		ПутьКФайлу2 = "";
		
		Если ПараметрыВыполнения.ДанныеФайла1.НомерВерсии < ПараметрыВыполнения.ДанныеФайла2.НомерВерсии Тогда
			ПутьКФайлу1 = ПараметрыВыполнения.ПолноеИмяФайла1;
			ПутьКФайлу2 = ПараметрыВыполнения.ПолноеИмяФайла2;
		Иначе
			ПутьКФайлу1 = ПараметрыВыполнения.ПолноеИмяФайла2;
			ПутьКФайлу2 = ПараметрыВыполнения.ПолноеИмяФайла1;
		КонецЕсли;
		
		РаботаСФайламиКлиент.СравнитьФайлы(
			ПутьКФайлу1, ПутьКФайлу2, ПараметрыВыполнения.СпособСравненияВерсийФайлов);
		
	КонецЕсли;
	
	Состояние();
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьВерсииВВидеДерева(Команда)
	
	ПоказатьВерсииВВидеДереваСервер();
	
КонецПроцедуры

&НаСервере
Процедура ПоказатьВерсииВВидеДереваСервер()
	
	ПолныйПоказСпискаВерсий = Не ПолныйПоказСпискаВерсий;
	ЗаполнитьДеревоВерсий();
	
	Если Не ПолныйПоказСпискаВерсий Тогда
		Элементы.ПоказатьВерсииВВидеДерева.Пометка = Ложь;
		Элементы.ПоказатьВерсииВВидеСписка.Пометка = Истина;
	Иначе
		Элементы.ПоказатьВерсииВВидеДерева.Пометка = Истина;
		Элементы.ПоказатьВерсииВВидеСписка.Пометка = Ложь;
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьВерсииВВидеСписка(Команда)
	
	ПоказатьВерсииВВидеДереваСервер();
	
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)

	ЗаполнитьДеревоВерсий();
	
	Если Не ПолныйПоказСпискаВерсий Тогда
		Элементы.ПоказатьВерсииВВидеДерева.Пометка = Ложь;
		Элементы.ПоказатьВерсииВВидеСписка.Пометка = Истина;
	Иначе
		Элементы.ПоказатьВерсииВВидеДерева.Пометка = Истина;
		Элементы.ПоказатьВерсииВВидеСписка.Пометка = Ложь;
	КонецЕсли;	
	
КонецПроцедуры
