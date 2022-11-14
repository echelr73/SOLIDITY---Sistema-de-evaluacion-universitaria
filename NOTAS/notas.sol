// SPDX-License-Identifier: MIT
pragma solidity >=0.4.4 <0.9.0;
pragma experimental ABIEncoderV2;

contract notas {

    // Direccion del profesor
    address public profesor = msg.sender;

    // Mapping para relacionar el hash de la identidad alumno con su nota de examen
    mapping (bytes32 => uint) Notas;

    // Array de los alumnos que pidan revisiones de examen
    string [] revisiones;

    // Eventos
    event alumno_evalueado(bytes32);
    event evento_revision(string);

    // Funcion para evaluar alumnos
    function Evaluar(string memory _idAlumno, uint _nota) public UnicamenteProfesor(msg.sender){

        // Hash de la Identificacion del alumno
        bytes32 hash_idAlumno = keccak256(abi.encodePacked(_idAlumno));

        // Relacion entre el hash de la identificacion del alumno y su nota
        Notas[hash_idAlumno] = _nota;

        // Emision del evento
        emit alumno_evalueado(hash_idAlumno);
    }

    // Control de las funciones ejecutables por el profesor
    modifier UnicamenteProfesor(address _direccion){
        // Requiere que la direccion introducida por parametro sea igual al owner del contrato
        require(profesor == _direccion, "No tienes permiso para ejecutar esta funcion");
        _;
    }

    // Funcion para ver las notas de un alumno
    function VerNotas(string memory _idAlumno) public view returns(uint){
        // Hash de la Identificacion del alumno
        bytes32 hash_idAlumno = keccak256(abi.encodePacked(_idAlumno));

        // Nota asociada al hash del alumno
        return Notas[hash_idAlumno];
    }

    // Funcion para pedir revision del examen
    function Revision(string memory _idAlumno) public {
        // Almacenamiento de la entidad del alumno
        revisiones.push(_idAlumno);

        // Emision del evento revision
        emit evento_revision(_idAlumno);
    }

    //Ver las solicitudes de revision
    function VerSolicitudes() public view UnicamenteProfesor(msg.sender) returns(string[] memory){
        // Devolver los alumnos que pidieron revision
        return revisiones;
    }
}