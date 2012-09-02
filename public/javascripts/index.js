/*global Backbone, _, $ */

$(function () {
    "use strict";

    _.templateSettings = {
        interpolate : /\{\{(.+?)\}\}/g
    };

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

            this.boosterPack.push(takeRandomElement(mythicRareCards.length !== 0 && Math.random() < 1 / 8 ? mythicRareCards : rareCards));
            var i;
            for (i = 0; i < 3; i = i + 1) {
                this.boosterPack.push(takeRandomElement(uncommonCards));
            }
            for (i = 0; i < 10; i = i + 1) {
                this.boosterPack.push(takeRandomElement(commonCards));
            }
            _.each(this.boosterPack, function (model) {
                this.el.append(_.template($("#card-image").text(), {card_image_url: model.get('card_image_url')}));
            }, this);
            return this;
        }
    });

    function cardSetFetch() {
        $('#cardSetDropdown').off('change');
        $("#reloadButton").off('click');

        $.getJSON('/card_property', {card_set: $('#cardSetDropdown').val()}, function (data) {
            var cardPropertyCollection = new Backbone.Collection();
            _.each(data, function (result) {
                cardPropertyCollection.add(new Backbone.Model(result));
            });
            var boosterPackView =  new BoosterPackView(cardPropertyCollection);

            $("#reloadButton").click(function () {
                boosterPackView.render();
                return false;
            });
            $('#cardSetDropdown').change(function () {
                cardSetFetch();
            });

            $("#reloadButton").click();
        });
    }
    cardSetFetch();
});
