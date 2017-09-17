function onLoadPickList(type1, type2, pickListId) {
    eventPickListDrop(type1, type2, pickListId);
    eventPickListSelect(type1, type2, pickListId);
    eventPickListLostFocus(type1, type2, pickListId);
}

function eventPickListDrop(type1, type2, pickListId) {
    var $pickList = $('#' + pickListId + ' #selected_' + type1 + '_' + type2);
    var $dropMenu = $('#' + pickListId + ' #drop_' + type1 + '_' + type2);
    $pickList.click(function () {
        if($dropMenu.hasClass('hide')) {
            $dropMenu.removeClass('hide');
        } else {
            $dropMenu.addClass('hide');
        }
    });
}

function eventPickListSelect(type1, type2, pickListId) {
    var $listItem = $('#' + pickListId + ' #drop_' + type1 + '_' + type2 + ' li.active-result');
    var $listLabel = $('#' + pickListId + ' #span_' + type1 + '_' + type2);
    var $dropList = $('#' + pickListId + ' #drop_' + type1 + '_' + type2);
    var $hiddenVal = $('#' + pickListId + ' #hidden_pick_' + type1 + '_' + type2);

    var clickEvent = function() {
        if($dropList.hasClass('hide')) {
            return;
        }
        var $clicked = $(this);
        var selectedText = $clicked.text();
        var selectedValue = $clicked.attr('data-id');
        $clicked.parent().children('li.active-result').each(function () {
            $(this).removeClass('result-selected');
        });
        $listLabel.text(selectedText);
        $dropList.addClass('hide');
        $hiddenVal.val(selectedValue);
    };

    $listItem
        .click(clickEvent)
        .mousedown(clickEvent);
}

function eventPickListLostFocus(type1, type2, pickListId) {
    var $pickList = $('#' + pickListId + ' #selected_' + type1 + '_' + type2);
    var $dropMenu = $('#' + pickListId + ' #drop_' + type1 + '_' + type2);
    $pickList.focusout(function () {
        if(!$dropMenu.hasClass('hide')) {
            $dropMenu.addClass('hide');
        }
    });
}