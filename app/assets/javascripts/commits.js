$(document).on('turbolinks:load', function() {
    setBaloon('.circle');
    eventOrgPicklist();
    eventRowAccordion();
});

function eventOrgPicklist() {
    $('#org-picklist li.active-result').mousedown(function () {
        var $selected = $(this);
        var $repoPickList = $('#repo-picklist');

        var orgId = $selected.attr('data-id');
        retrieveRepoPickList(orgId)
            .then(function(html) {
                $repoPickList.html(html);
            }).fail(function(err) {
                console.log(err);
            });

    });
}

function retrieveRepoPickList(orgId) {
    var deferred = new $.Deferred;
    $.ajax({
        url: '/orgs/' + orgId + '/repos',
        type: 'GET',
        success: deferred.resolve,
        error: deferred.reject
    });
    return deferred.promise();
}

function refreshPage() {
    var $pickOrg = $('#hidden_pick_info_org');
    var $pickRepo = $('#hidden_pick_info_repo');
    var $pickFrom = $('#hidden_pick_info_from');
    var $pickInterval = $('#hidden_pick_info_interval');

    var url =  '/orgs/' + $pickOrg.val() + '/repos/' + $pickRepo.val() + '/commits?' + 'from_date=' + $pickFrom.val() + '&interval=' + $pickInterval.val();
    Turbolinks.visit(url);
}

function eventRowAccordion() {
    $('.row').click(function() {
        var $clicked = $(this);
        var $checkbox = $clicked.find('input.accordion');
        $checkbox.prop("checked", !$checkbox.prop("checked"));
    });
}