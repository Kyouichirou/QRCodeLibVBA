Attribute VB_Name = "StructuredAppend"
'------------------------------------------------------------------------------
' �\���I�A��
'------------------------------------------------------------------------------
Option Private Module
Option Explicit


' �p���e�B�f�[�^�̃r�b�g��
Public Const PARITY_DATA_LENGTH As Long = 8

' �w�b�_�[�̃r�b�g��
Public Const HEADER_LENGTH As Long = _
    ModeIndicator.Length + _
    SymbolSequenceIndicator.POSITION_LENGTH + _
    SymbolSequenceIndicator.TOTAL_NUMBER_LENGTH + _
    PARITY_DATA_LENGTH
