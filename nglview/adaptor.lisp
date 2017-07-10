(in-package :nglv)

(defclass register_backend ()
  ((:package_name :initarg package_name :accessor package_name)))

(defmethod __call__ ((self register_backed) cls)
  (setf (gethash (package_name self) *BACKENDS*) cls)
  cls)

(defclass FileStructure(Structure)
  ((path :initarg :path :accessor path :initform nil)
   (fm :accessor fm :initform nil)
   (ext :accessor ext :initform nil)
   (params :accessor params :type list ;plist
	   :initform ())))

(defmethod initialize-instance :after ((FileStructure FileStructure) &key)
  (with-slots (path fm ext) FileStructure
    (setf fm (make-instance 'FileManager :path path))
    (setf ext (ext fm))))

;;(defgeneric get_structure_string (Structure)
;;  (:documentation "I think this works"))
(defmethod get_structure_string ((self FileStructure))
  (error "adaptor::get_structure_string error!! Implement me!"))
  #|
    def get_structure_string(self):
        return self.fm.read(force_buffer=True)
|#

(defclass TextStructure (Structure)
  ((text :initarg :text :accessor text :initform nil)
   (ext :initarg :ext :accessor ext :initform "pdb")
   (path :accessor path :initform "")
   (params :initarg params :accessor params :type list :initform ())))
  
(defmethod get_structure_string ((self TextStructure))
  (text self))

(defclass RdkitStructure (Structure)
  ((rdkit_mol :initarg :rdkit_mol :accessor rdkit_mol :initform nil)
   (ext :initarg :ext :accessor ext
	:initform "pdb")
   (path :accessor path :initform "")
   (params :accessor params :type list :initform ())))

(defmethod get_structure_string ((self RdkitStructure))
  (error "adaptor::get_structure_string Implement me!!!!"))
#|
 from rdkit import Chem
        fh = StringIO(Chem.MolToPDBBlock(self._rdkit_mol))
        return fh.read()
|#

(defclass PdbIdStructure (Structure)
  ((pdbid :initarg :pdbid :accessor pdbid :initform nil)
   (ext :accessor ext :initform "cif")
   (params :accessor params :type list :initform ())))

(defmethod get_structure_string ((self PdbIdStructure))
  (let ((url (concatenate 'string "http://www.rcsb.org/pdb/files/" (pdbid self) ".cif")))
    (error "adaptor::get_structure_string error! Implement me!")))
#|
    def get_structure_string(self):
        url = "http://www.rcsb.org/pdb/files/" + self.pdbid + ".cif"
        return urlopen(url).read()
|#

(defclass ASEStructure (Structure)
  ((ase_atoms :initarg :ase_atoms :accessor ase_atoms
	      :initform nil)
   (path :accessor path
	 :initform "")
   (params :initarg params :accessor params :type list :initform ())
   (ext :initarg :ext :accessor ext :initform "pdb")))

(defmethod get_structure_string ((self ASEStructure))
  (error "ASEStructure::get_structure_string help!!"))
#|
  def get_structure_string(self):
        with tempfolder():
            self._ase_atoms.write('tmp.pdb')
            return open('tmp.pdb').read()
|#

(defclass SimpletrajTrajectory (Trajectory Structure)
  ((path :initarg :path :accessor path :initform nil)
   (structure_path :initarg :structure_path :accessor structure_path :initform path)
   (traj_cache :accessor traj_cache :initform nil);HELP!!! Please help
   (ext :accessor ext :initform nil) ;HELP!!! Please help me
   (params :accessor params :type list :initform nil)
   (trajectory :accessor trajectory :initform nil)
   (id :accessor id :initform (format nil "~W" (uuid:make-v4-uuid)))))

(defmethod get_coordinates ((self SimpletrajTrajectory) index)
  (error "Implement me!!! get_coordinates SimpletrajTrajectory!"))
#|
    def get_coordinates(self, index):
        traj = self.traj_cache.get(os.path.abspath(self.path))
        frame = traj.get_frame(index)
        return frame["coords"]
|#

(defmethod get_structure_string ((self SimpletrajTrajectory))
  (error "help get_structure_string of simpletrajtrajectory"))
  ;;;return open(self._structure_path).read()

(defmethod n_frames ((self SimpletrajTrajectory))
  (error "n_frames simpletrajtrajectory needs some help"))
;;; traj = self.traj_cache.get(os.path.abspath(self.path))
;;; return traj.numframes

(defclass MDTrajTrajectory (Trajectory Structure)
  ((trajectory :initarg :trajectory :accessor trajectory
	       :initform nil)
   (ext :accessor ext :initform "pdb")
   (params :accessor params :type list :initform ())
   (id :accessor id :initform (format nil "~W" (uuid:make-v4-uuid)))))

(defmethod get_coordinates ((self MDTrajTrajectory) index)
  (* 10 (aref (xyz (trajectory self)) index)))

(defmethod n_frames ((self MDTrajTrajectory))
  (n_frames (trajectory self)))

(defmethod get_structure_string ((self MDTrajTrajectory))
  (error "Help the get_structure_String MDTrajTrajectory"))
#|
 def get_structure_string(self):
        fd, fname = tempfile.mkstemp()
        self.trajectory[0].save_pdb(fname)
        pdb_string = os.fdopen(fd).read()
        # os.close( fd )
        return pdb_string
|#

(defclass PyTrajTrajectory (Trajectory Structure)
  ((trajectory :initarg :trajectory :accessor trajectory
	       :initform nil)
   (ext :accessor ext :initform "pdb")
   (params :accessor params :type list :initform ())
   (id :accessor id :initform (format nil "~W" (uuid:make-v4-uuid)))))

(defmethod get_coordinates ((self PyTrajTrajectory) index)
  (xyz (aref (trajectory self) index)))

(defmethod n_frames ((self PyTrajTrajectory))
  (n_frames (trajectory self)))

(defmethod get_structure_string ((self PyTrajTrajectory))
  (error "PyTrajTrajecotry get_structure_string error"))
#|
    def get_structure_string(self):
        fd, fname = tempfile.mkstemp(suffix=".pdb")
        self.trajectory[:1].save(fname, format="pdb", overwrite=True)
        pdb_string = os.fdopen(fd).read()
        # os.close( fd )
        return pdb_string

|#
;;;There's something fishy goin on here. Check python code listed below.
(defclass ParmEdTrajectory (Trajecotry Structure)
  ((trajectory :initarg :trajectory :initform nil :accessor trajectory)
   (ext :accessor ext :initform "pdb")
   (params :accessor params :type list :initform ())
   (xyz :accessor xyz :initform nil)
   (id :accessor id  (format nil "~W" (uuid:make-v4-uuid)))
   (only_save_1st_model :accessor only_save_1st_model :type bool :initform :true)))

#|

@register_backend('parmed')
class ParmEdTrajectory(Trajectory, Structure):
    '''ParmEd adaptor.
    '''

    def __init__(self, trajectory):
        self.trajectory = trajectory
        self.ext = "pdb"
        self.params = {}
        # only call get_coordinates once
        self._xyz = trajectory.get_coordinates()
        self.id = str(uuid.uuid4())
        self.only_save_1st_model = True

    def get_coordinates(self, index):
        return self._xyz[index]

    @property
    def n_frames(self):
        return len(self._xyz)

    def get_structure_string(self):
        fd, fname = tempfile.mkstemp(suffix=".pdb")
        # only write 1st model
        if self.only_save_1st_model:
            self.trajectory.save(
                fname, overwrite=True,
                coordinates=self.trajectory.coordinates)
        else:
            self.trajectory.save(fname, overwrite=True)
        pdb_string = os.fdopen(fd).read()
        # os.close( fd )
        return pdb_string
|#

;(defmethod initialize-instance :after ((self ParmEdTrajectory) &key)
;;  (setf (xyz self) ((get_coordinates

(defclass MDAnalysisTrajectory (Trajectory Structure)
  ((atomgroup :initarg :atomgroup :accessor atomgroup)
   (ext :accessor ext :initform "pdb")
   (params :accessor params :type list :initform ())
   (id :accessor id :initform (format nil "~W" (uuid:make-v4-uuid)))))

(defmethod get_coordinates ((self MDAnalysisTrjaectory) index)
  (aref (trajectory (universe (atomgroup self))) index)
  (let xyz (positions (atoms (atomgroup self)))
       xyz))

(defmethod n_frames ((self MDAnalysisTrajectory))
  (n_frames (trajectory (universe (atomgroup self)))))

(defmethod get_structure_string ((self MDAnalysisTrajectory))
  (error "help MDAnalysisTrajectory get_structure_string"))

#|
  def get_structure_string(self):
        try:
            import MDAnalysis as mda
        except ImportError:
            raise ImportError(
                "'MDAnalysisTrajectory' requires the 'MDAnalysis' package"
            )
        u = self.atomgroup.universe
        u.trajectory[0]
        f = mda.lib.util.NamedStream(StringIO(), 'tmp.pdb')
        atoms = self.atomgroup.atoms
        # add PDB output to the named stream
        with mda.Writer(f, atoms.n_atoms, multiframe=False) as W:
            W.write(atoms)
        # extract from the stream
        pdb_string = f.read()
        return pdb_string

|#

(defclass HTMDTrajectory (Trajectory)
  ((mol :initarg :mol :accessor mol)
   (ext :accessor ext :initform "pdb")
   (params :accessor params :type list :initform ())
   (id :accessor id :initform (format nil "~W" (uuid:make-v4-uuid)))))

(defmethod get_coordinates ((self HTMDTrajectory) index)
  (error "help get_coordinates HTMDTrajectory"))
#|
    def get_coordinates(self, index):
        return np.squeeze(self.mol.coords[:, :, index])
|#

(defmethod n_frames ((self HTMDTrajectory))
  (numFrames (mol self)))

(defmethod get_structure ((self HTMDTrajectory))
  (error "help get_structure of HTMDTrajectory"))
#|
    def get_structure_string(self):
        import tempfile
        fd, fname = tempfile.mkstemp(suffix='.pdb')
        self.mol.write(fname)
        pdb_string = os.fdopen(fd).read()
        # os.close( fd )
        return pdb_string
|#