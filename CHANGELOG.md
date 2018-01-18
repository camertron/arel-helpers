## 2.6.0
* Add the join alias helper.
* Add ability to pass table aliases to join_association.

## 2.5.0
* Add license information to gemspec so it is parsed by verifiers (@petergoldstein #31)
* Update QueryBuilder#reflect to create deep copy of builder (@wycleffsean #32)

## 2.4.0
* Adding support for Rails 5.1 (@hasghari #30)

## 2.3.0
* Adding support for Rails 5 (@vkill #24, @camertron #26)

## 2.2.0
* Adding polymorphic join support for Rails 4.2.

## 2.1.1
* Fixing issue causing ArelTable instances to get returned when accessing records inside an ActiveRecord::Relation. (@svoynow, #18)

## 2.1.0
* Adding support for Rails 4.2 (@hasghari, github issue #12)

## 2.0.2
* Fix issue causing CollectionProxy#[] to return Arel::Attribute objects instead of model instances. See https://github.com/camertron/arel-helpers/pull/11

## 2.0.1
* Define ArelHelpers.join_association so people can use join_association functionality without relying on autoloading. (@peeja, github issue #8)

## 2.0.0
* Turning JoinAssociation into an ActiveSupport::Concern (breaks backwards compatibility).

## 1.2.0
* Adding Rails 4 support.

## 1.1.0
* Adding the QueryBuilder class.

## 1.0.0
* Birthday! Includes join_association and arel_table helpers.
