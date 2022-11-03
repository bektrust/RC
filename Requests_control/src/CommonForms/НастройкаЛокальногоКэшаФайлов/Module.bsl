&НаСервере
Процедура ОбновитьПараметрыНаСервере()
	
	УдалятьФайлИзЛокальногоКэшаФайловПриЗавершенииРедактирования 
		= ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(
			"ЛокальныйКэшФайлов", "УдалятьФайлИзЛокальногоКэшаФайловПриЗавершенииРедактирования");
	Если УдалятьФайлИзЛокальногоКэшаФайловПриЗавершенииРедактирования = Неопределено Тогда
		УдалятьФайлИзЛокальногоКэшаФайловПриЗавершенииРедактирования = Ложь;
	КонецЕсли;
	
	ОчищатьПриЗавершенииРаботы 
		= ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить("ЛокальныйКэшФайлов", 
			"ОчищатьПриЗавершенииРаботы", Ложь);
	
	ПодтверждатьПриУдаленииИзЛокальногоКэшаФайлов = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(
		"ЛокальныйКэшФайлов", "ПодтверждатьПриУдаленииИзЛокальногоКэшаФайлов");
	Если ПодтверждатьПриУдаленииИзЛокальногоКэшаФайлов = Неопределено Тогда
		ПодтверждатьПриУдаленииИзЛокальногоКэшаФайлов = Ложь;
	КонецЕсли;
	
	МаксРазмер = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(
		"ЛокальныйКэшФайлов", "МаксимальныйРазмерЛокальногоКэшаФайлов");
	Если МаксРазмер = Неопределено Тогда
		МаксРазмер = 100*1024*1024; // 100 мб		
		ОбщегоНазначения.ХранилищеОбщихНастроекСохранить("ЛокальныйКэшФайлов", "МаксимальныйРазмерЛокальногоКэшаФайлов", МаксРазмер);
	КонецЕсли;
	МаксимальныйРазмерЛокальногоКэшаФайлов = МаксРазмер / 1048576;

КонецПроцедуры

&НаКлиенте
Процедура ОбновитьПараметрыНаКлиенте()
	ФайловыеФункцииКлиент.ПроинициализироватьПутьКРабочемуКаталогу();
	ПутьКЛокальномуКэшуФайлов = ФайловыеФункцииКлиентПовтИсп.ПолучитьПерсональныеНастройкиРаботыСФайлами().ПутьКЛокальномуКэшуФайлов;
	
	#Если НЕ ВебКлиент Тогда
		МассивФайлов = НайтиФайлы(ПутьКЛокальномуКэшуФайлов, "*.*");
		РазмерФайловВРабочемКаталоге = 0;
		КоличествоСуммарное = 0;
		ФайловыеФункцииКлиент.ОбходФайловРазмер(ПутьКЛокальномуКэшуФайлов, МассивФайлов, РазмерФайловВРабочемКаталоге, КоличествоСуммарное); 
		
		РазмерФайловВРабочемКаталоге = РазмерФайловВРабочемКаталоге / 1048576;
	#КонецЕсли
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьПараметры()
	ОбновитьПараметрыНаСервере();
	ОбновитьПараметрыНаКлиенте();
КонецПроцедуры

&НаКлиенте
Процедура СохранитьВыполнить()
	
	Если ИмяКаталогаПрежнееЗначение <> ПутьКЛокальномуКэшуФайлов Тогда
		
#Если Не ВебКлиент Тогда		
		Обработчик = Новый ОписаниеОповещения("СохранитьВыполнитьПродолжить", ЭтотОбъект);
		РаботаСФайламиКлиент.ПеренестиСодержимоеРабочегоКаталога(Обработчик, ИмяКаталогаПрежнееЗначение, ПутьКЛокальномуКэшуФайлов);
		Возврат;
#КонецЕсли		
	КонецЕсли;	

	СохранитьВыполнитьПродолжить(Истина, Неопределено);
	
КонецПроцедуры

&НаКлиенте
Процедура СохранитьВыполнитьПродолжить(Ответ, ПараметрыВыполнения) Экспорт
	
	Если Ответ <> Истина Тогда
		Возврат;
	КонецЕсли;	
	
	МассивСтруктур = Новый Массив;
	
	Элемент = Новый Структура;
	Элемент.Вставить("Объект", "ЛокальныйКэшФайлов");
	Элемент.Вставить("Настройка", "ПутьКЛокальномуКэшуФайлов");
	Элемент.Вставить("Значение", ПутьКЛокальномуКэшуФайлов);
	МассивСтруктур.Добавить(Элемент);
	
	Элемент = Новый Структура;
	Элемент.Вставить("Объект", "ЛокальныйКэшФайлов");
	Элемент.Вставить("Настройка", "МаксимальныйРазмерЛокальногоКэшаФайлов");
	Элемент.Вставить("Значение", МаксимальныйРазмерЛокальногоКэшаФайлов * 1048576);
	МассивСтруктур.Добавить(Элемент);
	
	Элемент = Новый Структура;
	Элемент.Вставить("Объект", "ЛокальныйКэшФайлов");
	Элемент.Вставить("Настройка", "УдалятьФайлИзЛокальногоКэшаФайловПриЗавершенииРедактирования");
	Элемент.Вставить("Значение", УдалятьФайлИзЛокальногоКэшаФайловПриЗавершенииРедактирования);
	МассивСтруктур.Добавить(Элемент);
	
	Элемент = Новый Структура;
	Элемент.Вставить("Объект", "ЛокальныйКэшФайлов");
	Элемент.Вставить("Настройка", "ПодтверждатьПриУдаленииИзЛокальногоКэшаФайлов");
	Элемент.Вставить("Значение", ПодтверждатьПриУдаленииИзЛокальногоКэшаФайлов);
	МассивСтруктур.Добавить(Элемент);
	
	Элемент = Новый Структура;
	Элемент.Вставить("Объект", "ЛокальныйКэшФайлов");
	Элемент.Вставить("Настройка", "ОчищатьПриЗавершенииРаботы");
	Элемент.Вставить("Значение", ОчищатьПриЗавершенииРаботы);
	МассивСтруктур.Добавить(Элемент);
	
	ОбщегоНазначенияВызовСервера.ХранилищеОбщихНастроекСохранитьМассивИОбновитьПовторноИспользуемыеЗначения(МассивСтруктур);
	
	ФайловыеФункцииКлиент.ПроинициализироватьПутьКРабочемуКаталогу();
	
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	РасширениеПодключено = ФайловыеФункцииСлужебныйКлиент.РасширениеРаботыСФайламиПодключено();
	Если НЕ РасширениеПодключено Тогда
		ПоказатьПредупреждение(,НСтр("ru = 'В Веб-клиенте без установленного расширения работы с файлами настройка рабочего каталога не поддерживается.'"));
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	ОбновитьПараметрыНаКлиенте();
	ИмяКаталогаПрежнееЗначение = ПутьКЛокальномуКэшуФайлов;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокФайловВыполнить()
	
	Обработчик = Новый ОписаниеОповещения("ПослеСписокФайловВыполнить", ЭтотОбъект);
	ОткрытьФорму("Справочник.Файлы.Форма.СписокФайловВЛокальномКэшеФайлов",,,,,,Обработчик);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеСписокФайловВыполнить(Ответ, ПараметрыВыполнения) Экспорт
	
	ПутьКЛокальномуКэшуФайловВФорме = ПутьКЛокальномуКэшуФайлов;
	ОбновитьПараметры();
	ПутьКЛокальномуКэшуФайлов = ПутьКЛокальномуКэшуФайловВФорме;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьВыполнить()
	ОбновитьПараметры();
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	ОбновитьПараметрыНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ОчиститьЛокальныйКэшФайлов(Команда)
	
#Если НЕ ВебКлиент Тогда
	
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"ОчиститьЛокальныйКэшФайловПродолжение",
		ЭтотОбъект);
		
	ТекстВопроса = НСтр("ru = 'Из основного рабочего каталога будут удалены все файлы, кроме занятых вами для редактирования. Продолжить?'");
	ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет);	
	
#КонецЕсли

КонецПроцедуры

&НаКлиенте
Процедура ОчиститьЛокальныйКэшФайловПродолжение(Ответ, Параметры) Экспорт
	
#Если НЕ ВебКлиент Тогда
	Если Ответ <> КодВозвратаДиалога.Да Тогда
		Возврат;
	КонецЕсли;
	
	Состояние(НСтр("ru = 'Выполняется очистка основного рабочего каталога... 
					|Пожалуйста, подождите.'"));
	ИмяКаталога = ОбщегоНазначенияВызовСервера.ХранилищеОбщихНастроекЗагрузить("ЛокальныйКэшФайлов", "ПутьКЛокальномуКэшуФайлов");
	
	МассивФайлов = НайтиФайлы(ИмяКаталога, "*.*");
	
	РазмерФайловВРабочемКаталоге = 0;
	КоличествоСуммарное = 0;
	ФайловыеФункцииКлиент.ОбходФайловРазмер(ИмяКаталога, МассивФайлов, РазмерФайловВРабочемКаталоге, КоличествоСуммарное);
	
	Обработчик = Новый ОписаниеОповещения("ОчиститьЛокальныйКэшФайловЗавершение", ЭтотОбъект);
	// ОчищатьВсе = Истина.
	РаботаСФайламиКлиент.ОчиститьРабочийКаталог(Обработчик, РазмерФайловВРабочемКаталоге, 0, Истина);
	
#КонецЕсли
	
КонецПроцедуры

&НаКлиенте
Процедура ОчиститьЛокальныйКэшФайловЗавершение(Результат, ПараметрыВыполнения) Экспорт
	
	РазмерФайловВРабочемКаталоге = РазмерФайловВРабочемКаталоге / 1048576;
	
	ПутьКЛокальномуКэшуФайловВФорме = ПутьКЛокальномуКэшуФайлов;
	ОбновитьПараметры();
	ПутьКЛокальномуКэшуФайлов = ПутьКЛокальномуКэшуФайловВФорме;
	Состояние(НСтр("ru = 'Очистка основного рабочего каталога успешно завершена.'"));		
	
КонецПроцедуры

&НаКлиенте
Процедура ПутьКЛокальномуКэшуФайловНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если НЕ ФайловыеФункцииСлужебныйКлиент.РасширениеРаботыСФайламиПодключено() Тогда
		Возврат;
	КонецЕсли;
	
	// выбираем другой путь к рабочему каталогу
	ИмяКаталога = ПутьКЛокальномуКэшуФайлов;
	Заголовок = НСтр("ru = 'Выберите путь к основному рабочему каталогу'");
	Если Не РаботаСФайламиКлиент.ВыбратьПутьКРабочемуКаталогу(ИмяКаталога, Заголовок, Ложь) Тогда
		Возврат;
	КонецЕсли;	
	
	ПутьКЛокальномуКэшуФайлов = ИмяКаталога;
	
КонецПроцедуры

&НаКлиенте
Процедура ПутьКРабочемуКаталогуПоУмолчанию(Команда)
	
	ПутьКЛокальномуКэшуФайловВременный = ФайловыеФункцииКлиент.ПолучитьПутьККаталогуДанныхПользователя();
	
	Если ПутьКЛокальномуКэшуФайлов = ПутьКЛокальномуКэшуФайловВременный Тогда
		Возврат;
	КонецЕсли;	
	
	ПутьКЛокальномуКэшуФайлов = ПутьКЛокальномуКэшуФайловВременный;
КонецПроцедуры
