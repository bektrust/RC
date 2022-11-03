////////////////////////////////////////////////////////////////////////////////
// МОДУЛЬ СОДЕРЖИТ РЕАЛИЗАЦИЮ МЕХАНИКИ РАБОТЫ С ФАЙЛАМИ - Интерфейсные функции
// 

// Создает карточку Файла в БД вместе с версией.
// 
// Параметры:
//  Владелец - Ссылка - владелец файла, который будет установлен в реквизит ВладелецФайла у созданного файла.
//
//  ПутьКФайлуНаДиске  - Строка - полный путь к файлу на диске, включающий имя и расширение файла.
//                       Файл должен находиться на сервере.
//
// Возвращаемое значение:
//  СправочникСсылка.Файлы - созданный файл.
//
Функция СоздатьФайлНаОсновеФайлаНаДиске(Владелец, ПутьКФайлуНаДиске, ИмяФайла = Неопределено) Экспорт
	
	Файл = Новый Файл(ПутьКФайлуНаДиске);
	
	ДвоичныеДанные = Новый ДвоичныеДанные(ПутьКФайлуНаДиске);
	АдресВременногоХранилищаФайла = ПоместитьВоВременноеХранилище(ДвоичныеДанные);
	
	АдресВременногоХранилищаТекста = "";
	
	ИзвлекатьТекстыФайловНаСервере = РаботаСФайламиВызовСервера.ПолучитьИзвлекатьТекстыФайловНаСервере();
	Если ИзвлекатьТекстыФайловНаСервере = Ложь Тогда
		
		// сами пытаемся извлечь текст  - если сервер под Windows
		Если ФайловыеФункции.ЭтоПлатформаWindows() Тогда
			Текст = ФайловыеФункцииКлиентСервер.ИзвлечьТекст(ПутьКФайлуНаДиске);
			АдресВременногоХранилищаТекста = Новый ХранилищеЗначения(Текст);
		КонецЕсли;
		
	Иначе
		АдресВременногоХранилищаТекста = ""; // фоновое задание извлечения текста извлечет текст
	КонецЕсли;
	
	Если ИмяФайла = Неопределено Тогда
		ИмяФайла = Файл.ИмяБезРасширения;
	КонецЕсли;
	
	СведенияОФайле = РаботаСФайламиКлиентСервер.СведенияОФайле("ФайлСВерсией", Файл);
	СведенияОФайле.АдресВременногоХранилищаФайла = АдресВременногоХранилищаФайла;
	СведенияОФайле.ИмяБезРасширения = ИмяФайла;
	СведенияОФайле.АдресВременногоХранилищаТекста = АдресВременногоХранилищаТекста;
	Возврат РаботаСФайламиВызовСервера.СоздатьФайлСВерсией(Владелец, СведенияОФайле);
	
КонецФункции	

