library organizations_comp;

import 'package:pritunl/collections/organizations.dart' as organizations;
import 'package:pritunl/collections/users.dart' as usrs;
import 'package:pritunl/models/user.dart' as usr;

import 'package:angular/angular.dart' show Component;
import 'package:angular/angular.dart' as ng;

@Component(
  selector: 'organizations',
  templateUrl: 'packages/pritunl/components/organizations/organizations.html',
  cssUrl: 'packages/pritunl/components/organizations/organizations.css'
)
class OrganizationsComp implements ng.AttachAware, ng.ScopeAware {
  Set<usr.User> selected = new Set();
  organizations.Organizations orgs;
  ng.Http http;

  OrganizationsComp(this.http) {
    this.orgs = new organizations.Organizations(this.http);
    this.update();
  }

  void update() {
    this.orgs.fetch();
  }

  void set scope(ng.Scope scope) {
    scope.on('organizations_updated').listen((evt) {
      this.orgs.fetch();
    });
  }

  void attach() {
    this.orgs.onAdd = (model) {
      model.users = new usrs.Users(this.http);
      model.users.org = model.id;
      model.users.onRemove = (userModel) {
        this.selected.remove(userModel);
      };
      if (model.users.page == null) {
        model.users.page = 0;
      }
      model.users.fetch();
    };
  }
}
