$(document).on('turbolinks:load', function() {
    setBaloon('.circle');
});

function refreshPage() {
    var $pickOrg = $('#hidden_pick_info_org');
    var $pickRepo = $('#hidden_pick_info_repo');
    var $pickFrom = $('#hidden_pick_info_from');
    var $pickInterval = $('#hidden_pick_info_interval');

    var url =  '/orgs/' + $pickOrg.val() + '/repos/' + $pickRepo.val() + '/commits?' + 'from_date=' + $pickFrom.val() + '&interval=' + $pickInterval.val();
    Turbolinks.visit(url);
}