using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Dissolve : MonoBehaviour
{
  public float DissolveTime = 3f;
  private MeshRenderer meshRenderer;
  void Start()
  {
    meshRenderer = GetComponent<MeshRenderer>();
  }

  // Update is called once per frame
  void Update()
  {
    if (Input.GetKeyUp(KeyCode.Return))
    {
      StartCoroutine("StartDissolve");
    }
  }

  private IEnumerator StartDissolve()
  {
    SetDissolveValue(0);
    float time = 0f;
    while (time < DissolveTime)
    {
      time += Time.deltaTime;
      SetDissolveValue(time / DissolveTime);
      yield return null;
    }
  }
  private void SetDissolveValue(float value)
  {
    int shaderId = Shader.PropertyToID("_Alpha_Clip");

    meshRenderer.materials[0].SetFloat(shaderId, value);
  }
}
