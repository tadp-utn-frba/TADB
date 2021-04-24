# TADB

Version: 0.3.7

> *Note*: This gem is intended only for academic purposes only, and not for general use. Also it's intended to be 
> used on the Tecnicas Avanzadas de Programacion Subject only. The following instructions will be described in Spanish instead as intended.

TADB es una gema cuyo proposito es la de simular la persistencia a una base de datos. La misma permite una persistencia a disco utilizando la lireria estandar de [Ruby](https://ruby-doc.org/core-3.0.0/File.html).

## Instalacion

Hay que agregar la siguiente linea al Gemfile del proyecto que utilizara la gema

```ruby
gem 'tadb'
```

Despues solo hay que instalar de nuevo las dependencias restantes 

    $ bundle install

#### Alternativa

Tambien se puede 

    $ gem install tadb

## Usage

Para utilizar la gema primero hay que hacer el require de la misma

```ruby
require 'tadb'
```

### Introduccion y DB

Luego, dentro del módulo TADB se encuentra el objeto DB. Este entiende un mensaje [table(table_name)](https://github.com/tadp-utn-frba/TADB/blob/master/lib/tadb/db.rb#L5) que retorna una interfaz para escribir en un archivo del nombre indicado en la carpeta `/db` en la raíz del proyecto.

> Nota Importante: Es recomendable que el nombre de la tabla sea distinto en los tests, que en el uso normal del codigo que use esta gema. Tambien en el caso de los tests, es recomendable el borrado de las DB presentes en 

Con lo cual se puede iniciar la creacion de una nueva tabla de esta manera

```ruby
tabla = TADB::DB.table('blah')
=> #<TADB::Table:0x00005624fc0b4420 @name="blah">
```

esto crea una nueva tabla. De aqui en mas todas las llamadas restantes son en funcion de la entidad `Table` se puede ver el codigo [aqui](./lib/tadb/table.rb)

> Nota: a partir de la version 0.3.7, hay un flag `clear_if_content`, que chequea, en el caso de que este seteado en true, que si hay algun contenido en el archivo que especifican en el parametro de nombre, borre los contenidos. El flag esta seteado en false por defecto.

Antes de seguir con lo que se pueden hacer sobre las tablas, DB tiene un metodo mas, que es el de `clear_all`, este [metodo](https://github.com/tadp-utn-frba/TADB/blob/master/lib/tadb/db.rb#L9) borra todos los archivos de la carpeta `/db`, que es donde residen todas las tablas que pueden crear con esta gema. Un caso de uso de esto puede ser para limpiar los tests, cuando los corran. Un ejemplo de esto es en los specs de la gema misma cuando testeamos los metodos de `table.rb` [aqui](https://github.com/tadp-utn-frba/TADB/blob/master/spec/table_spec.rb#L5).

Esta carpeta `/db` probablemente deberá borrarse y volverse a crear a medida que se ejecuten los tests, para evitar que el resultado de un test impacte al siguiente, por eso recomendamos o bien el `clear_all` de DB, o el mensaje `clear` de cada tabla, cada vez que finalizen cada test en un bloque `after` de [rspec](https://relishapp.com/rspec/rspec-core/v/3-10/docs/hooks/before-and-after-hooks).

#### Sobre la clase Table...

Si bien llamamos tablas a lo que nos da el DB, en realidad no lo son, son solo un mock que esta representado por medio de un `Hash` y que tiene capacidad de persistencia nada mas, cuando agreguemos o saquemos datos.

##### Insert

Cada “tabla” permite insertar un `Hash` (mapas de clave valor utilizados por Ruby que pueden crearse con el literal: {clave_uno: valor_uno, clave_2: valor_2, ...} ) que representa una fila de la tabla, utilizando el mensaje insert(hash). `Siempre que un hash se inserta se genera un id para la nueva entrada y se lo persiste como una fila nueva`. `Los hashes solo pueden tener valores primitivos al persistirse: Strings, números o booleanos.`

Un ejemplo de esto puede verse como 

```ruby
id = table.insert({subject: 'tadp'})
Forcing sync on file ./db/blah...
=> "ff621bd3-da9d-4d25-bedb-8df3bde8cf2a"
```

el id devuelto sobre el insert nos va a permitir despues trabajar la eliminacion de dicha entrada mediante el mensaje `delete`.

##### Entries

Las tablas también permiten listar todas las entradas con el mensaje `entries`. Éste devuelve una lista de todos los hashes persistidos en el archivo al momento de ejecutar el método.

un ejemplo de esto:

```ruby
entries = table.entries
[{:subject=>"tadp", :id=>"ff621bd3-da9d-4d25-bedb-8df3bde8cf2a"}]
```

El resultado 

##### Delete

Finalmente, las tablas también entienden el mensaje `delete(id)`, que borra de la tabla la entrada cuyo id es el que se pasó por parámetro, y el mensaje clear, que borra todas las entradas de una tabla.

un ejemplo de esto:

```ruby
pry(main)> table.delete(id)
=> []
```

El resultado nos da la tabla ya sin el id que se ha eliminado. Como en el caso, la tabla solo tenia un registro, la tabla resultante es vacia. En cambio si tenemos dos entradas por ejemplo.

```ruby
table.insert({subject: 'tadp'})
id = table.insert({subject: 'iasc'})
=> "24cf46ef-7999-4acb-bec5-f613393b4991"
table.entries
=> [{:subject=>"tadp", :id=>"4e7f85c4-d4ed-4d68-bcf7-936102814c81"},
 {:subject=>"iasc", :id=>"24cf46ef-7999-4acb-bec5-f613393b4991"}]
table.delete(id)
=> [{:subject=>"tadp", :id=>"4e7f85c4-d4ed-4d68-bcf7-936102814c81"}]
```

## Desarrollo

Una vez que se hayan bajado este repositorio, deben instalar las dependencias asociadas, mediante `bundle install`. 
Despues hay que correr `rake spec`, para correr los tests, o en su defecto `bundle exec rspec spec`

Para instalar la gema en la maquina localmente, con cambios realizados, deben hacer `bundle exec rake install`.


#### Como hacer el realease de una nueva version (de uso interno)

Para hacer una nueva version de la gema, deben actualizar el numero de la version en `tad.rb`, 
y despues correr `bundle exec rake release`, que creara un nuevo tag con la version, pushea los tags al repo de github, 
y envia el archivo que compone la gema, de extension `.gem`, a [rubygems.org](https://rubygems.org).

## Contribuciones y Bugs

Si encuentran algun problema o bug utilizando la gema porfavor, abrir un issue en el [issue tracker](https://github.com/tadp-utn-frba/TADB/issues).
Este proyecto está destinado a ser un espacio seguro y acogedor para la colaboración, y se espera que los contribuyentes se adhieran a las [normas de conducta](http://contributor-covenant.org).

## Licencia

Esta gema esta bajo la licencia de [MIT](http://opensource.org/licenses/MIT) de codigo abierto.

## Code of Conduct

Se espera que todos los que interactúen con el código del proyecto Tadb, issue tracker, salas de chat y las listas de correo sigan las [normas de conducta](https://github.com/tadp-utn-frba/tadb/blob/master/CODE_OF_CONDUCT.md).


## Changelog

Se pueden ver los cambios de cada version [aca](./CHANGELOG.md)