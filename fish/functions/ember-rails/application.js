// new one
import DS from "ember-data";

var ApplicationAdapter = DS.RESTAdapter.extend({
  host: 'http://localhost:3000',
  shouldReloadAll: function(){
    return true;  
  }
});

export default ApplicationAdapter;
