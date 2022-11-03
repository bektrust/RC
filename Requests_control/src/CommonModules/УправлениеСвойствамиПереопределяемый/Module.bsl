////////////////////////////////////////////////////////////////////////////////
// Подсистема "Свойства"
// 
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Заполняет наборы свойств объекта. Обычно требуется, если наборов более одного.
//
// Параметры:
//  Объект       - Ссылка на владельца свойств.
//                 Объект владельца свойств.
//                 ДанныеФормыСтруктура (по типу объекта владельца свойств).
//
//  ТипСсылки    - Тип - тип ссылки владельца свойств.
//
//  НаборыСвойств - ТаблицаЗначений с колонками:
//                    Набор - СправочникСсылка.НаборыДополнительныхРеквизитовИСведений.
//
//                    // Далее свойства элемента формы типа ГруппаФормы вида обычная группа
//                    // или страница, которая создается, если наборов больше одного без учета
//                    // пустого набора, который описывает свойства группы удаленных реквизитов.
//                    
//                    // Если значение Неопределено, значит использовать значение по умолчанию.
//                    
//                    // Для любой группы управляемой формы.
//                    Высота                   - Число.
//                    Заголовок                - Строка.
//                    Подсказка                - Строка.
//                    РастягиватьПоВертикали   - Булево.
//                    РастягиватьПоГоризонтали - Булево.
//                    ТолькоПросмотр           - Булево.
//                    ЦветТекстаЗаголовка      - Цвет.
//                    Ширина                   - Число.
//                    ШрифтЗаголовка           - Шрифт.
//                    
//                    // Для обычной группы и страницы.
//                    Группировка              - ГруппировкаПодчиненныхЭлементовФормы.
//                    
//                    // Для обычной группы.
//                    Отображение                - ОтображениеОбычнойГруппы.
//                    ШиринаПодчиненныхЭлементов - ШиринаПодчиненныхЭлементовФормы.
//                    
//                    // Для страницы.
//                    Картинка                 - Картинка.
//                    ОтображатьЗаголовок      - Булево.
//
//  СтандартнаяОбработка - Булево - начальное значение Истина. Указывает получать ли
//                         основной набор, когда НаборыСвойств.Количество() равно нулю.
//
//  КлючНазначения   - Неопределено - (начальное значение) - указывает вычислить
//                      ключ назначения автоматически и добавить к значениям свойств
//                      формы КлючНазначенияИспользования и КлючСохраненияПоложенияОкна,
//                      чтобы изменения формы (настройки, положение и размер) сохранялись
//                      отдельно для разного состава наборов.
//                      Например, для каждого вида номенклатуры - свой состав наборов.
//
//                    - Строка - (не более 32 символа) - использовать указанный ключ
//                      назначения для добавления к значениям свойств формы.
//                      Пустая строка - не изменять свойства ключей формы, т.к. они
//                      устанавливается в форме и уже учитывают различия состава наборов.
//
//                    Добавка имеет формат "КлючНаборовСвойств<КлючНазначения>",
//                    чтобы <КлючНазначения> можно было обновлять без повторной добавки.
//                    При автоматическом вычислении <КлючНазначения> содержит хэш
//                    идентификаторов ссылок упорядоченных наборов свойств.
//
Процедура ЗаполнитьНаборыСвойствОбъекта(Объект, ТипСсылки, НаборыСвойств, СтандартнаяОбработка, КлючНазначения) Экспорт
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

////////////////////////////////////////////////////////////////////////////////
// Вспомогательные процедуры и функции.

Процедура ЗаполнитьНаборыСвойствПоВидуДокумента(ВидДокумента, НаборыСвойств) Экспорт
	
	Если ЗначениеЗаполнено(ВидДокумента) И ЗначениеЗаполнено(ВидДокумента.НаборСвойств) Тогда
		ДобавитьСтрокуНабора(НаборыСвойств, ВидДокумента.НаборСвойств);
	КонецЕсли;
	
	//ДобавитьСтрокуНабора(НаборыСвойств,
	//	Справочники.НаборыДополнительныхРеквизитовИСведений.Справочник_ДоговорныеДокументы_Общие);
	
КонецПроцедуры

Процедура ЗаполнитьНаборыСвойствПоВидуКонтрагента(ЮрФизЛицо, НаборыСвойств) Экспорт
	
	Если ЮрФизЛицо = Перечисления.ЮридическоеФизическоеЛицо.ЮридическоеЛицо Тогда
		ДобавитьСтрокуНабора(НаборыСвойств,
			Справочники.НаборыДополнительныхРеквизитовИСведений.Справочник_Контрагенты_ЮрЛицо);
	ИначеЕсли ЮрФизЛицо = Перечисления.ЮридическоеФизическоеЛицо.ФизическоеЛицо Тогда
		ДобавитьСтрокуНабора(НаборыСвойств,
			Справочники.НаборыДополнительныхРеквизитовИСведений.Справочник_Контрагенты_ФизЛицо);
	ИначеЕсли ЮрФизЛицо = Перечисления.ЮридическоеФизическоеЛицо.ИндивидуальныйПредприниматель Тогда
		ДобавитьСтрокуНабора(НаборыСвойств,
			Справочники.НаборыДополнительныхРеквизитовИСведений.Справочник_Контрагенты_ИП);
	КонецЕсли;
	
	ДобавитьСтрокуНабора(НаборыСвойств,
		Справочники.НаборыДополнительныхРеквизитовИСведений.Справочник_Контрагенты_Общие);
		
КонецПроцедуры

Процедура ДобавитьСтрокуНабора(НаборыСвойств, ЗначениеНабора)
	
	Строка = НаборыСвойств.Добавить();
	Строка.Набор = ЗначениеНабора;
	
КонецПроцедуры

#КонецОбласти