
class Record {
  String _area;
  String _date = '';
  String _meter = '';
  String _mult = '';
  String _user = '';
  String _variance = '';
  String _percentage = '';
  String _presentreading = '';
  String _previousreading = '';
  String _presentconsumption = '';
  String _previousconsumption = '';
  String _remarks = '';

  Record(
  this._area,
  this._date,
  this._meter,
  this._mult,
  this._user,
  this._variance,
  this._percentage,
  this._presentreading,
  this._previousreading,
  this._presentconsumption,
  this._previousconsumption,
  this._remarks,
  );

  /* GETTERS */
  get area => _area;
  get date => _date;
  get meter => _meter;
  get mult => _mult;
  get user => _user;
  get variance => _variance;
  get percentage => _percentage;
  get presentreading => _presentreading;
  get previousreading => _previousreading;
  get presentconsumption => _presentconsumption;
  get previousconsumption => _previousconsumption;
  get remarks => _remarks;

  /* SETTERS */
  set area(String area) {
    this._area = area;
  }

  set date(String date) {
    this._date = date;
  }
  
  set meter(String meter) {
    this._meter = meter;
  }
  set mult(String mult) {
    this._mult = mult;
  }
  set user(String user) {
    this._user = user;
  }
  set variance(String variance) {
    this._variance = variance;
  }
  set percentage(String percentage) {
    this._percentage = percentage;
  }
  set presentreading(String presentreading) {
    this._presentreading = presentreading;
  }
  set previousreading(String previousreading) {
    this._previousreading = previousreading;
  }
  set presentconsumption(String presentconsumption) {
    this._presentconsumption = presentconsumption;
  }
  set previousconsumption(String previousconsumption) {
    this._previousconsumption = previousconsumption;
  }
  set remarks(String remarks) {
    this._remarks = remarks;
  }

  Record.create(Map<String, dynamic> data){
    this._area = data['area'];
    this._date = data['date'];
    this._meter = data['meter'];
    this._mult = data['mult'];
    this._user = data['user'];
    this._variance = data['variance'];
    this._percentage = data['percentage'];
    this._presentreading = data['presentreading'];
    this._previousreading = data['previousreading'];
    this._presentconsumption = data['presentconsumption'];
    this._previousconsumption = data['previousconsumption'];
    this._remarks = data['remarks'];
  }
}