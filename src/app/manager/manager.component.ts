import { Component, OnInit } from "@angular/core";
import { ActivatedRoute, Data, Params, Router } from "@angular/router";
import { LoadingService } from "../loading.service";
import { ApiService } from "../api.service";

@Component({
  selector: "app-manager",
  templateUrl: "./manager.component.html",
  styleUrls: ["./manager.component.css"],
})
export class ManagerComponent implements OnInit {
  username;
  showLocation = false;
  showRiders = false;
  showCustomers = false;

  constructor(
    private route: ActivatedRoute,
    private loadingService: LoadingService,
    private apiService: ApiService
  ) {}

  ngOnInit() {
    this.loadingService.loading.next(true);
    this.route.params.subscribe((params: Params) => {
      this.username = params.username;
      this.apiService
        .getUserByUsername(this.username)
        .subscribe((test: any) => {
          console.log(test);
        });
    });
    this.loadingService.loading.next(false);
  }

  seeLocation() {
    this.showLocation = true;
    this.showCustomers = false;
    this.showRiders = false;
  }

  seeRiders() {
    this.showLocation = false;
    this.showCustomers = false;
    this.showRiders = true;
  }

  seeCustomers() {
    this.showLocation = false;
    this.showCustomers = true;
    this.showRiders = false;
  }
}
