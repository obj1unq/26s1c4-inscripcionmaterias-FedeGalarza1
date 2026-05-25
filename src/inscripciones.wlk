class Estudiante {
  var property materiasQueTieneElEstudiante = []
	var carreras = [] 
  var property materiasYaInscripta = [] 

  method inscribirseEnCarreras(carrera) {
  carreras.add(carrera)
}

	method inscripcion (){
		return carreras.map({ carrera => carrera.materiaDeCarrera() }).flatten()
	}

  method aprobar(materia, nota) {

    if (self.aprobo(materia)) {
      self.error("Ya aprobaste") // tira error si la aprueba viene del metodo de aprobo
    }

    materiasQueTieneElEstudiante.add(
      new MateriaAprobada ( // agrega si aprobo la materia, hecho en clase.  Para preguntar si hay otro metodo. 
        materia = materia,
        nota = nota
      )
    )
  } 

  method agregarMateria(materia) {
    materiasYaInscripta.add(materia)
  }

  method aprobo(materia) {

   return materiasQueTieneElEstudiante.map({ m => m.materia() }).contains(materia)
  }
	method cantidadAprobadas() {
  return materiasQueTieneElEstudiante.size() // me da la cantidad de materias aprobadas 
}
	method promedio() {
  return materiasQueTieneElEstudiante.sum({ // suma las materias que tengo aprobadas devuelve un numero que divido por el tama;o de la lista 
    numero => numero.nota()
  }) / materiasQueTieneElEstudiante.size()
}

method sePuedeInscribir(materia) {
  return self.inscripcion().contains(materia) && !self.aprobo(materia) && !materiasYaInscripta.contains(materia) && materia.correlativas().all({ correlativa => self.aprobo(correlativa) })
}

method materiasEnListaDeEspera() {
  return self.inscripcion().filter({ materia => materia.listaDeEspera().contains(self) }) // me devuelve las materias en las que el el estudiantes figura en lista de espera. 
}

method materiasDeCarreraAInscribir(carrera) {

	if (!carreras.contains(carrera)) {
		self.error("No cursa esa carrera")
	}

	return carrera.materiaDeCarrera().filter({materia => self.sePuedeInscribir(materia)}) // Polimorfismo carreras materia y estudiante. Necesito filtrar la lista de materias de cada carrera, para despues ver si se puede incribir en cada materia. 
}

}


class Carrera{ // la carrera tiene el nombre de la carrera y la lista de materias 
  var property materiaDeCarrera = []

}
class Materia{ // la materia tiene que saber el nombre y de que carrera es 
var property correlativas = [] 
const cupo 
var property listaDeEspera = [] 
var property estudiantesInscriptos = [] 

method inscribir(estudiante) {
   if (!estudiante.sePuedeInscribir(self)) {
    self.error("No cumple los requisitos")
  }
  if (estudiantesInscriptos.size() < cupo) {
    estudiantesInscriptos.add(estudiante)
    estudiante.agregarMateria(self)
  } else {
    listaDeEspera.add(estudiante)
  }
}

method bajaDeEstudianteInscripto(estudiante) {
    estudiantesInscriptos.remove(estudiante)
      if (listaDeEspera.size() > 0) {
      const estudianteEnEspera = listaDeEspera.first()  
      listaDeEspera.remove(estudianteEnEspera)
      estudiantesInscriptos.add(estudianteEnEspera) // antes de pasar por la lista de estudiantes inscriptos, tuvo que usar inscribir para verifijar 
      estudianteEnEspera.agregarMateria(self)
  }
}

}
class MateriaAprobada { // esto da para que se guarde en materias materiasQueTieneElEstudiante
const property materia  // No se usa para comparar, se usa para agregar cuando se recorre 
const property nota  

}

