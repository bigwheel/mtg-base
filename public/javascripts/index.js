/*jslint vars: true */
/*jslint nomen: true */ // for underscore.js
/*global Backbone, _, $ */

(function () {
	"use strict";

	/*jslint regexp: true */
	_.templateSettings = {
		interpolate : /\{\{(.+?)\}\}/g
	};
	/*jslint regexp: false */

	var CardPropertyModel = Backbone.Model.extend({
	});
	var CardPropertyCollection = Backbone.Collection.extend({
		model: CardPropertyModel
	});

	function getRandomInt(maxButNotContain) {
		return Math.floor(Math.random() * maxButNotContain);
	}
	function getRandomElement(array) {
		return array[getRandomInt(array.length)];
	}
	function takeElement(array, index) {
		var value = array[index];
		array.splice(index, 1);
		return value;
	}
	function takeRandomElement(array) {
		return takeElement(array, getRandomInt(array.length));
	}

	var BoosterPackView = Backbone.View.extend({
		reset: function () {
			this.boosterPack = [];
			this.el.empty();
		},
		initialize: function (cardPoolCollection) {
			this.cardPoolCollection = cardPoolCollection;
			this.el = $("#boosterPack");
			this.reset();
		},
		render: function () {
			this.reset();
			var mythicRareCards = this.cardPoolCollection.where({rarity: "Mythic Rare"});
			var rareCards = this.cardPoolCollection.where({rarity: "Rare"});
			var uncommonCards = this.cardPoolCollection.where({rarity: "Uncommon"});
			var commonCards = this.cardPoolCollection.where({rarity: "Common"});
			var basicLandCards = this.cardPoolCollection.where({rarity: "Basic Land"});

			this.boosterPack.push(takeRandomElement(Math.random() < 1 / 8 ? mythicRareCards : rareCards));
			var i;
			for (i = 0; i < 3; i = i + 1) {
				this.boosterPack.push(takeRandomElement(uncommonCards));
			}
			for (i = 0; i < 10; i = i + 1) {
				this.boosterPack.push(takeRandomElement(commonCards));
			}
			function getLandOrFoil() {
				if (Math.random() < 1 / 8) {
					return getRandomElement((function getCardPoolFromProbability() {
						var nthCardInPack = getRandomInt();
						if (nthCardInPack <= 0) {
							return Math.random() < 1 / 8 ? mythicRareCards : rareCards;
						}
						if (nthCardInPack <= 3) {
							return uncommonCards;
						}
						if (nthCardInPack <= 13) {
							return commonCards;
						}
						return basicLandCards;
					}()));
				}
				return getRandomElement(basicLandCards);
			}
			this.boosterPack.unshift(getLandOrFoil(this));
			_.each(this.boosterPack, function (model) {
				this.el.append(_.template($("#card-image").text(), {multiverseid: model.get('multiverseid')}));
			}, this);
			return this;
		}
	});

	$.getJSON('/cardproperty', null, function (data) {
		var cardPropertyCollection = new CardPropertyCollection();
		_.each(data, function (result) {
			cardPropertyCollection.add(new CardPropertyModel(result));
		});
		var boosterPackView =  new BoosterPackView(cardPropertyCollection);
		boosterPackView.render();
		$("#reloadButton").click(function (event) {
			boosterPackView.render();
		});
	});
}());
